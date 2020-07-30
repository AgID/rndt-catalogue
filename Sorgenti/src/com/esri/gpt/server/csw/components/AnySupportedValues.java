/* See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * Esri Inc. licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.esri.gpt.server.csw.components;

/**
 * A collection where any value is supported. 
 */
public class AnySupportedValues implements ISupportedValues {
  
  /** constructors ============================================================ */
  
  /** Default constructor */
  public AnySupportedValues() {}
  
  /** methods ================================================================= */
  
  /**
   * Gets the supported value associated with a requested value.
   * @param requestedValue the requested value
   * @return the supplied value is always returned
   */
  public String getSupportedValue(String requestedValue) {
    return requestedValue;
  }
  
  /**
   * Determines if a requested value is supported.
   * @param requestedValue the requested value
   * @return always <code>true</code> 
   */
  public boolean isValueSupported(String requestedValue) {
    return true;
  }

    @Override
    public String getSupportedValueCs(String requestedValue) {
        return requestedValue;
    }

    @Override
    public boolean isValueSupportedCs(String value) {
        return true;
    }

}
