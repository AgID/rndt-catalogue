/*
 * Copyright 2015 pete5162.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.esri.gpt.control.webharvest.engine;

import com.esri.gpt.agp.client.AgpException;
import com.esri.gpt.agp.client.AgpItem;
import com.esri.gpt.agp.sync.AgpDestination;
import com.esri.gpt.agp.sync.Gpt2AgpPush;
import com.esri.gpt.agp.sync.GptSource;
import com.esri.gpt.catalog.harvest.protocols.HarvestProtocolGpt2Agp;
import com.esri.gpt.catalog.harvest.repository.HrUpdateLastSyncDate;
import com.esri.gpt.control.webharvest.protocol.Protocol;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.http.HttpClientException;
import com.esri.gpt.framework.resource.query.Result;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author pete5162
 */
public abstract class Gpt2AgpExecutor extends Executor {

  /**
   * logger
   */
  private static final Logger LOGGER = Logger.getLogger(Gpt2AgpExecutor.class.getCanonicalName());

  /**
   * Creates instance of the executor.
   * @param dataProcessor data processor
   * @param unit execution unit
   */
  public Gpt2AgpExecutor(DataProcessor dataProcessor, ExecutionUnit unit) {
    super(dataProcessor, unit);
  }

  @Override
  public void execute() {
    RequestContext context = RequestContext.extract(null);

    boolean success = false;
    long count = 0;
    Result result = null;
    final ExecutionUnit unit = getExecutionUnit();
    LOGGER.log(Level.FINEST, "[SYNCHRONIZER] Starting pushing through unit: {0}", unit);
    if (isActive()) {
      getProcessor().onStart(getExecutionUnit());
    }

    ExecutionUnitHelper helper = new ExecutionUnitHelper(getExecutionUnit());
    // get report builder
    final ReportBuilder rp = helper.getReportBuilder();

    try {
      Protocol protocol = getExecutionUnit().getRepository().getProtocol();
      if (protocol instanceof HarvestProtocolGpt2Agp) {
        HarvestProtocolGpt2Agp p = (HarvestProtocolGpt2Agp)protocol;
        GptSource source = p.getSource();
        AgpDestination destination = p.getDestination();
        
        Gpt2AgpPush agpPush = new Gpt2AgpPush(source, destination) {
          private long counter;

          @Override
          protected boolean syncItem(AgpItem sourceItem, String uuid, String xml) throws Exception {
            counter++;
            String sourceUri = sourceItem.getProperties().getValue("id");
            try {
              boolean result = super.syncItem(sourceItem, uuid, xml);
              if (result) {
                rp.createEntry(sourceUri, result);
                LOGGER.log(Level.FINEST, "[SYNCHRONIZER] Pushed item #{0} of source URI: \"{1}\" through unit: {2}", new Object[]{counter, sourceItem.getProperties().getValue("id"), unit});
              } else {
                rp.createUnpublishedEntry(sourceUri, Arrays.asList(new String[]{"Ignored"}));
                LOGGER.log(Level.FINEST, "[SYNCHRONIZER] Rejected item #{0} of source URI: \"{1}\" through unit: {2}", new Object[]{counter, sourceItem.getProperties().getValue("id"), unit});
              }
              return result;
            } catch (AgpException ex) {
              LOGGER.log(Level.WARNING, "[SYNCHRONIZER] Failed pushing item #{0} of source URI: \"{1}\" through unit: {2}. Reason: {3}", new Object[]{counter, sourceItem.getProperties().getValue("id"), unit, ex.getMessage()});
              rp.createUnpublishedEntry(sourceUri, Arrays.asList(new String[]{ex.getMessage()}));
              return false;
            } catch (HttpClientException ex) {
              LOGGER.log(Level.WARNING, "[SYNCHRONIZER] Failed pushing item #{0} of source URI: \"{1}\" through unit: {2}. Reason: {3}", new Object[]{counter, sourceItem.getProperties().getValue("id"), unit, ex.getMessage()});
              rp.createUnpublishedEntry(sourceUri, Arrays.asList(new String[]{ex.getMessage()}));
              return false;
            } catch (Exception ex) {
              throw ex;
            }
          }

          @Override
          protected boolean doContinue() {
            boolean doContinue = Gpt2AgpExecutor.this.isActive();
            if (!doContinue) {
              unit.setCleanupFlag(false);
            }
            return doContinue;
          }
          
        };
        agpPush.synchronize();
      }

      success = true;

      if (isActive()) {
        // save last sync date
        getExecutionUnit().getRepository().setLastSyncDate(rp.getStartTime());
        HrUpdateLastSyncDate updLastSyncDate = new HrUpdateLastSyncDate(context, unit.getRepository());
        updLastSyncDate.execute();
      }
    } catch (Exception ex) {
      rp.setException(ex);
      unit.setCleanupFlag(false);
      LOGGER.log(Level.FINEST, "[SYNCHRONIZER] Failed pushing through unit: {0}. Cause: {1}", new Object[]{unit, ex.getMessage()});
      getProcessor().onIterationException(getExecutionUnit(), ex);
    } finally {
      if (!isShutdown()) {
        getProcessor().onEnd(unit, success);
        context.onExecutionPhaseCompleted();
      }
      if (result != null) {
        result.destroy();
      }
      LOGGER.log(Level.FINEST, "[SYNCHRONIZER] Completed pushing through unit: {0}. Obtained {1} records.", new Object[]{unit, count});
    }
  }
}
