/*
 * Copyright 2013 Esri.
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
package com.esri.gpt.framework.dcat.adaptors;

import com.esri.gpt.framework.dcat.dcat.DcatDistribution;
import com.esri.gpt.framework.dcat.json.JsonAttributes;


/**
 * DCAT distribution adaptor.
 */
class DcatDistributionAdaptor extends DcatAdaptor implements DcatDistribution {

  public DcatDistributionAdaptor(JsonAttributes attrs) {
    super(attrs);
  }

  @Override
  public String getAccessURL() {
    return getString("accessURL");
  }

  @Override
  public String getFormat() {
    return getString("format");
  }

  @Override
  public String getMediaType() {
    return getString("mediaType");
  }

  @Override
  public String getType() {
    return getString("@type");
  }

  @Override
  public String getConformsTo() {
    return getString("conformsTo");
  }

  @Override
  public String getDescribedBy() {
    return getString("describedBy");
  }

  @Override
  public String getDescribedByType() {
    return getString("describedByType");
  }

  @Override
  public String getDescription() {
    return getString("description");
  }

  @Override
  public String getDownloadURL() {
    return getString("downloadURL");
  }

  @Override
  public String getTitle() {
    return getString("title");
  }
  
  @Override
  public String toString() {
    return "{ " +attrs.toString() + " }";
  }
}
