/*******************************************************************************
 * Copyright (c) 2008-2011 Dima Berastau and Contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * Redistributions of files must retain the above copyright notice.
 ******************************************************************************/
package org.restfulx.services {
  import org.restfulx.Rx;
  import org.restfulx.services.GenericServiceErrors;
  import org.restfulx.utils.RxUtils;
  import org.restfulx.utils.TypedArray;
  import org.restfulx.utils.ServiceErrors;
  
  /**
   * AMFServiceProvider specific IServiceErrors implementation.
   */
  public class AMFServiceErrors extends GenericServiceErrors {
    /**
     * Transforms errors into an array of Validation results
     * mapped by field name.
     *  
     * @param result errors response
     */   
    public function AMFServiceErrors(result:ServiceErrors) {
      super();
      for (var key:String in result.errors) {        
        if (errors[key] == null) {
          errors[key] = [createValidationResult(result.errors[key])];
        } else {
          (errors[key] as Array).push(createValidationResult(result.errors[key]));
        }
      }
    }
  }
}