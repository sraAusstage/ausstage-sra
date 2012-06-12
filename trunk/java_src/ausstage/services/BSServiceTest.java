/*
 * Copyright 2001-2004 The Apache Software Foundation.
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

package ausstage.services;

//import com.sun.org.omg.CORBA.ParameterMode;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.encoding.XMLType;
import org.apache.axis.utils.Options;




public class BSServiceTest
{
    public static void main(String [] args)
    {
    	try {
            Options options = new Options(args);
           
            String endpointURL = options.getURL();
            String textToSend;
            
            args = options.getRemainingArgs();
            if ((args == null) || (args.length < 1)) {
                textToSend = "<nothing>";
            } else {
                textToSend = args[0];
            }
            
            Service  service = new Service();
            Call     call    = (Call) service.createCall();
            
            call.setTargetEndpointAddress( new java.net.URL(endpointURL) );
            //call.setOperationName( new QName("http://ausstage.services", "callSearch") );
            call.setOperationName( new QName("http://www.ausstage.edu.au:8088/services/BSService", "callSearch") );
            //call.setOperationName( new QName("-lhttp://sapac24.cc.flinders.edu.au:8088/axis/services/BSService", "callSearch") );
            call.addParameter( "arg1", XMLType.XSD_STRING, javax.xml.rpc.ParameterMode.IN);
            call.addParameter( "arg2", XMLType.XSD_STRING, javax.xml.rpc.ParameterMode.IN);
            call.addParameter( "arg3", XMLType.XSD_STRING, javax.xml.rpc.ParameterMode.IN);
            call.addParameter( "arg4", XMLType.XSD_STRING, javax.xml.rpc.ParameterMode.IN);
            call.addParameter( "arg5", XMLType.XSD_STRING, javax.xml.rpc.ParameterMode.IN);
            call.setReturnType( org.apache.axis.encoding.XMLType.XSD_STRING );

            //String ret = (String) call.invoke( new Object[] { args[0],args[1],args[2],args[3],args[4]} );
            String ret = (String) call.invoke( new Object[] { "hamlet","1997","alphab_frwd","and","all"} );
            
            System.out.println("Results");
            System.out.println("" + ret);
        } catch (Exception e) {
            System.err.println(e.toString());
            System.err.println(((org.apache.axis.AxisFault)e).getFaultReason());
            e.printStackTrace();
        }
    }
}
