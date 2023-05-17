/*--------------------------------------------------------
    desc : class for updating the custom metadata values with master list of legacy System.
    created on  2-Sep-2021
    created by : athar@chikpea.com & sayantan@chikpea.com

---------------------------------------------------------*/

public with sharing class UpdateMasterListCustomMetadata {    
    
    // api 5.1 update district and region list in custom metadata as per the legacy system response.
    
    public static String parseDistJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'District' and DIST_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String Districtmap = JSON.serialize(respMap.get('meta_data'));
                System.debug('Districtmap =========>'+Districtmap);
                Map<String, Object> DistrictListmap = (Map<String, Object>)JSON.deserializeUntyped(Districtmap);
                System.debug('DistrictListmap =======>'+DistrictListmap);
                List<Object> DistrictList =(List<Object>) DistrictListmap.get('dist_list');

                if(DistrictList != NULL && DistrictList.size()>0){
                    System.debug('============DistrictList Size=====================>'+DistrictList.size());
                    list<List_Storage__c> DistrictListFinal = new list<List_Storage__c>();

                    for(Object d : DistrictList){
                        Map<String, Object> djsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(d));
                        System.debug('cjsonmap1 ======>'+djsonmap1);

                        if(djsonmap1!= NULL && djsonmap1.size()>0){
                            List_Storage__c lsDistrict = new List_Storage__c();
                            lsDistrict.DIST_TERR__c = String.valueOf(djsonmap1.get('dist_terr'));  
                            lsDistrict.DIST_RGN__c = String.valueOf(djsonmap1.get('dist_rgn')); 
                            lsDistrict.DIST__c = String.valueOf(djsonmap1.get('dist')); 
                            lsDistrict.SUB_DIST__c = String.valueOf(djsonmap1.get('sub_dist')); 
                            lsDistrict.DIST_TERR_HK__c = String.valueOf(djsonmap1.get('dist_terr_hk'));  
                            lsDistrict.DIST_RGN_HK__c = String.valueOf(djsonmap1.get('dist_rgn_hk')); 
                            lsDistrict.DIST_HK__c = String.valueOf(djsonmap1.get('dist_hk')); 
                            lsDistrict.SUB_DIST_HK__c = String.valueOf(djsonmap1.get('sub_dist_hk')); 
                            lsDistrict.DIST_Active__c = true;     
                            lsDistrict.List_Type__c = 'District';                  
                            DistrictListFinal.add(lsDistrict);
                        }
                    }

                    System.debug('Final List of District Inserted ======>'+DistrictListFinal);
                    if(DistrictListFinal != null && DistrictListFinal.size()>0){
                        insert DistrictListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of District deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    }

    /*
    TEMP comment
    public static String parseRegionJsonData(String jsonstr){
        // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"dist_list":
        // [{"dist_terr":"HONG KONG","dist_rgn":"HK ISLAND","dist":"CENTRAL & WESTERN","sub_dist":"ADMIRALTY",
        // "dist_terr_hk":"香港","dist_rgn_hk":"香港島","dist_hk":"中西區","sub_dist_hk":"金鐘"},........... continue
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String regionmap = JSON.serialize(respMap.get('meta_data'));
                System.debug('regionmap ====>'+regionmap);
                Map<String, Object> regionlistmap = (Map<String, Object>)JSON.deserializeUntyped(regionmap);
                System.debug('regionlistmap ====>'+regionlistmap);
                List<Object> distList =(List<Object>) regionlistmap.get('dist_list');
                if(distList != NULL && distList.size()>0){
                    for(Object dist : distList){
                        System.debug('dist ====>'+dist);
                        System.debug('JSON.serialize(dist) ======>'+JSON.serialize(dist));
                        Map<String, Object> distjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(dist));
                        System.debug('distjsonmap1 ======>'+ distjsonmap1);
                        if(distjsonmap1!= NULL && distjsonmap1.size()>0){
                            Map<String, String> distjsonmap = new Map<String, String> ();
                            for(String key : distjsonmap1.keySet()){
                                distjsonmap.put(key, String.valueOf(distjsonmap1.get(key)));
                            }
                            jsonmapList.add(distjsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updateDistMetadata(jsonmapList);                
                return 'job placed in queue with id '+jobid;               
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return null;
    }
    public static String insertDistMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String distregname1 = jsonObject.get('sub_dist');
                    distregname1 +='_'+ jsonObject.get('dist');
                    distregname1 +='_'+ jsonObject.get('dist_rgn');
                    distregname1 +='_'+ jsonObject.get('dist_terr');
                    String distregname2 = distregname1.trim();
                    String distregname3 = distregname2.remove('(');
                    String distregname4 = distregname3.remove(')');
                    String distregname5 = distregname4.remove('\'');
                    String distregname6 = distregname5.remove(',');
                    String distregname71 = distregname6.remove('-');
                    String distregname72 = distregname71.replace('&', 'n');
                    String distregname7 = distregname72.remove('.');
                    String distregname8 = ((distregname7 != NULl && distregname7.length()>=40)?distregname7.substring(0, 39):distregname7).trim();
                    String distregname = distregname8.replace(' ', '_');
                    System.debug('distregname before insert ====>'+distregname);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'District__mdt.'+distregname).removeEnd('_');
                    firstMetadataRec.label = ((distregname2 != NULL && distregname2.length()>=40)?distregname2.substring(0,39):distregname2).trim(); //jsonObject.get('ctry_name');   // distregname;    
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'District__c';
                    customField1.value = jsonObject.get('dist');
                    firstMetadataRec.values.add(customField1);
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'District_HK__c';
                    customField2.value = jsonObject.get('dist_hk');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'District_Region__c';
                    customField3.value = jsonObject.get('dist_rgn');
                    firstMetadataRec.values.add(customField3);
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'District_Region_HK__c';
                    customField4.value = jsonObject.get('dist_rgn_hk');
                    firstMetadataRec.values.add(customField4);
                    Metadata.CustomMetadataValue customField5 = new Metadata.CustomMetadataValue();
                    customField5.field = 'District_Territory__c';
                    customField5.value = jsonObject.get('dist_terr');
                    firstMetadataRec.values.add(customField5);
                    Metadata.CustomMetadataValue customField6 = new Metadata.CustomMetadataValue();
                    customField6.field = 'District_Territory_HK__c';
                    customField6.value = jsonObject.get('dist_terr_hk');
                    firstMetadataRec.values.add(customField6);
                    Metadata.CustomMetadataValue customField7 = new Metadata.CustomMetadataValue();
                    customField7.field = 'Sub_District__c';
                    customField7.value = jsonObject.get('sub_dist');
                    firstMetadataRec.values.add(customField7);
                    Metadata.CustomMetadataValue customField8 = new Metadata.CustomMetadataValue();
                    customField8.field = 'Sub_District_HK__c';
                    customField8.value = jsonObject.get('sub_dist_hk');
                    firstMetadataRec.values.add(customField8);

                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateDistMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String distregname1 = jsonObject.get('sub_dist');
                    distregname1 +='_'+ jsonObject.get('dist');
                    distregname1 +='_'+ jsonObject.get('dist_rgn');
                    distregname1 +='_'+ jsonObject.get('dist_terr');
                    String distregname2 = distregname1.trim();
                    String distregname3 = distregname2.remove('(');
                    String distregname4 = distregname3.remove(')');
                    String distregname5 = distregname4.remove('\'');
                    String distregname6 = distregname5.remove(',');
                    String distregname71 = distregname6.remove('-');
                    String distregname72 = distregname71.replace('&', 'n');
                    String distregname7 = distregname72.remove('.');
                    String distregname8 = ((distregname7 != NULl && distregname7.length()>=40)?distregname7.substring(0, 39):distregname7).trim();
                    String distregname = distregname8.replace(' ', '_');
                    System.debug('distregname before update ====>'+distregname);
                    District__mdt ccode = District__mdt.getInstance(distregname);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'District__mdt.'+ccode.DeveloperName;
                        metadataRec.label = ((distregname2 != NULL && distregname2.length()>=40)?distregname2.substring(0,39):distregname2).trim();    // ccode.MasterLabel;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'District__c';
                        customField1.value = jsonObject.get('dist');
                        metadataRec.values.add(customField1);
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'District_HK__c';
                        customField2.value = jsonObject.get('dist_hk');
                        metadataRec.values.add(customField2);
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'District_Region__c';
                        customField3.value = jsonObject.get('dist_rgn');
                        metadataRec.values.add(customField3);
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'District_Region_HK__c';
                        customField4.value = jsonObject.get('dist_rgn_hk');
                        metadataRec.values.add(customField4);
                        Metadata.CustomMetadataValue customField5 = new Metadata.CustomMetadataValue();
                        customField5.field = 'District_Territory__c';
                        customField5.value = jsonObject.get('dist_terr');
                        metadataRec.values.add(customField5);
                        Metadata.CustomMetadataValue customField6 = new Metadata.CustomMetadataValue();
                        customField6.field = 'District_Territory_HK__c';
                        customField6.value = jsonObject.get('dist_terr_hk');
                        metadataRec.values.add(customField6);
                        Metadata.CustomMetadataValue customField7 = new Metadata.CustomMetadataValue();
                        customField7.field = 'Sub_District__c';
                        customField7.value = jsonObject.get('sub_dist');
                        metadataRec.values.add(customField7);
                        Metadata.CustomMetadataValue customField8 = new Metadata.CustomMetadataValue();
                        customField8.field = 'Sub_District_HK__c';
                        customField8.value = jsonObject.get('sub_dist_hk');
                        metadataRec.values.add(customField8);
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertDistMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */

    // api 5.2 @athar update master country list.

    public static String parseCntryJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Country' and CTRY_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String Countrymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('Countrymap =========>'+Countrymap);
                Map<String, Object> CountryListmap = (Map<String, Object>)JSON.deserializeUntyped(Countrymap);
                System.debug('CountryListmap =======>'+CountryListmap);
                List<Object> countryList =(List<Object>) CountryListmap.get('ctry_list');

                if(countryList != NULL && countryList.size()>0){
                    System.debug('============countryList Size=====================>'+countryList.size());
                    list<List_Storage__c> countryListFinal = new list<List_Storage__c>();

                    for(Object c : countryList){
                        Map<String, Object> cjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
                        System.debug('cjsonmap1 ======>'+cjsonmap1);

                        if(cjsonmap1!= NULL && cjsonmap1.size()>0){
                            List_Storage__c lscountry = new List_Storage__c();
                            lscountry.CTRY_CTRY_CODE__c = String.valueOf(cjsonmap1.get('ctry_code'));  
                            lscountry.CTRY_CTRY_NAME__c = String.valueOf(cjsonmap1.get('ctry_name')); 
                            lscountry.CTRY_CTRY_NAME_HK__c = String.valueOf(cjsonmap1.get('ctry_name_hk')); 
                            lscountry.CTRY_GRADE__c = String.valueOf(cjsonmap1.get('grade')); 
                            lscountry.CTRY_Active__c = true;     
                            lscountry.List_Type__c = 'Country';                  
                            countryListFinal.add(lscountry);
                        }
                    }

                    System.debug('Final List of Country Inserted ======>'+countryListFinal);
                    if(countryListFinal != null && countryListFinal.size()>0){
                        insert countryListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    } 

    /*
    public static String parseCntryJsonData(String jsonstr){
        // sample json
        // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"ctry_list":
        // [{"ctry_code":"ABW","ctry_name":"ARUBA","ctry_name_hk":"阿魯巴島"},............. continue
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String countrymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('countrymap ====>'+countrymap);
                Map<String, Object> countrylistmap = (Map<String, Object>)JSON.deserializeUntyped(countrymap);
                System.debug('countrylistmap====>'+countrylistmap);
                List<Object> countryList =(List<Object>) countrylistmap.get('ctry_list');
                if(countryList != NULL && countryList.size()>0){
                    for(Object cntry : countryList){
                        System.debug('cntry ======>'+cntry);
                        System.debug('JSON.serialize(cntry) ======>'+JSON.serialize(cntry));
                        Map<String, Object> ctryjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cntry));
                        System.debug('ctryjsonmap1 ======>'+ctryjsonmap1);
                        if(ctryjsonmap1!= NULL && ctryjsonmap1.size()>0){
                            Map<String, String> ctryjsonmap = new Map<String, String> ();
                            for(String key : ctryjsonmap1.keySet()){
                                ctryjsonmap.put(key, String.valueOf(ctryjsonmap1.get(key)));
                            }
                            jsonmapList.add(ctryjsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updateCountryMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertCountryMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String cntryname1 = jsonObject.get('ctry_name');
                    String cntryname2 = cntryname1.trim();
                    String cntryname3 = cntryname2.remove('(');
                    String cntryname4 = cntryname3.remove(')');
                    String cntryname5 = cntryname4.remove('\'');
                    String cntryname6 = cntryname5.remove(',');
                    String cntryname71 = cntryname6.remove('-');
                    String cntryname7 = cntryname71.remove('.');
                    String cntryname8 = ((cntryname7 != NULl && cntryname7.length()>=40)?cntryname7.substring(0, 39):cntryname7).trim();
                    String cntryname = cntryname8.replace(' ', '_');
                    System.debug('cntryname before insert ====>'+cntryname);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Country__mdt.'+cntryname).removeEnd('_');
                    firstMetadataRec.label = ((cntryname2 != NULL && cntryname2.length()>=40)?cntryname2.substring(0,39):cntryname2).trim(); //jsonObject.get('ctry_name');   // cntryname;    
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'Country_Code__c';
                    customField1.value = jsonObject.get('ctry_code');
                    firstMetadataRec.values.add(customField1);     
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'Country_Name_HK__c';
                    customField2.value = jsonObject.get('ctry_name_hk');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'Full_Country_Name__c';
                    customField3.value = jsonObject.get('ctry_name');
                    firstMetadataRec.values.add(customField3);  
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'grade__c';
                    customField4.value = jsonObject.get('grade');
                    firstMetadataRec.values.add(customField4);
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateCountryMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String cntryname1 = jsonObject.get('ctry_name');
                    String cntryname2 = cntryname1.trim();
                    String cntryname3 = cntryname2.remove('(');
                    String cntryname4 = cntryname3.remove(')');
                    String cntryname5 = cntryname4.remove('\'');
                    String cntryname6 = cntryname5.remove(',');
                    String cntryname71 = cntryname6.remove('-');
                    String cntryname7 = cntryname71.remove('.');
                    String cntryname8 = ((cntryname7 != NULl && cntryname7.length()>=40)?cntryname7.substring(0, 39):cntryname7).trim();
                    String cntryname = cntryname8.replace(' ', '_');
                    System.debug('cntryname before update ====>'+cntryname);
                    Country__mdt ccode = Country__mdt.getInstance(cntryname);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Country__mdt.'+ccode.DeveloperName;
                        metadataRec.label = ((cntryname2 != NULL && cntryname2.length()>=40)?cntryname2.substring(0,39):cntryname2).trim();    // ccode.MasterLabel;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'Country_Code__c';
                        customField1.value = jsonObject.get('ctry_code');
                        metadataRec.values.add(customField1);     
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'Country_Name_HK__c';
                        customField2.value = jsonObject.get('ctry_name_hk');
                        metadataRec.values.add(customField2);  
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'Full_Country_Name__c';
                        customField3.value = jsonObject.get('ctry_name');
                        metadataRec.values.add(customField3); 
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'grade__c';
                        customField4.value = jsonObject.get('grade');
                        metadataRec.values.add(customField4);
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertCountryMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */

    // api 5.3 @athar update the legal type list in custom metadata as per the legacy system reponse.

    public static String parseLegalTypeJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Legal Type' and LegalList_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String LegalTypemap = JSON.serialize(respMap.get('meta_data'));
                System.debug('LegalTypemap =========>'+LegalTypemap);
                Map<String, Object> LegalTypeListmap = (Map<String, Object>)JSON.deserializeUntyped(LegalTypemap);
                System.debug('LegalTypeListmap =======>'+LegalTypeListmap);
                List<Object> LegalTypeList =(List<Object>) LegalTypeListmap.get('legal_type_list');

                if(LegalTypeList != NULL && LegalTypeList.size()>0){
                    System.debug('============LegalTypeList Size=====================>'+LegalTypeList.size());
                    list<List_Storage__c> LegalTypeListFinal = new list<List_Storage__c>();

                    for(Object lt : LegalTypeList){
                        Map<String, Object> ltjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(lt));
                        System.debug('ltjsonmap1 ======>'+ltjsonmap1);

                        if(ltjsonmap1!= NULL && ltjsonmap1.size()>0){
                            List_Storage__c lsLegal = new List_Storage__c();
                            lsLegal.LegalList_Code_Group__c = String.valueOf(ltjsonmap1.get('code_group'));  
                            lsLegal.LegalList_Code__c = String.valueOf(ltjsonmap1.get('code')); 
                            lsLegal.LegalList_Code_Value__c = String.valueOf(ltjsonmap1.get('code_value'));     
                            lsLegal.LegalList_Code_Desc__c = String.valueOf(ltjsonmap1.get('code_desc'));
                            lsLegal.LegalList_Active__c = true;     
                            lsLegal.List_Type__c = 'Legal Type';                  
                            LegalTypeListFinal.add(lsLegal);
                        }
                    }

                    System.debug('Final List of Legal Inserted ======>'+LegalTypeListFinal);
                    if(LegalTypeListFinal!= null && LegalTypeListFinal.size()>0){
                        insert LegalTypeListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    } 

    /*
    public static String parseLegalJsonData(String jsonstr){
        // 
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String legalTypeMap = JSON.serialize(respMap.get('meta_data'));
                System.debug('legalTypeMap ====>'+legalTypeMap);
                Map<String, Object> legaltypelistMap = (Map<String, Object>)JSON.deserializeUntyped(legalTypeMap);
                System.debug('legaltypelistMap ====>'+legaltypelistMap);
                List<Object> legalList =(List<Object>) legaltypelistMap.get('legal_type_list');
                if(legalList != NULL && legalList.size()>0){
                    for(Object legal : legalList){
                        System.debug('legal ====>'+legal);
                        System.debug('JSON.serialize(legal) ======>'+JSON.serialize(legal));
                        Map<String, Object> legaljsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(legal));
                        System.debug('legaljsonmap1 ======>'+ legaljsonmap1);
                        if(legaljsonmap1!= NULL && legaljsonmap1.size()>0){
                            Map<String, String> legaljsonmap = new Map<String, String> ();
                            for(String key : legaljsonmap1.keySet()){
                                legaljsonmap.put(key, String.valueOf(legaljsonmap1.get(key)));
                            }
                            jsonmapList.add(legaljsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updateLegalMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertLegalMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String legalCode = jsonObject.get('code');
                    System.debug('LegalCode before insert ====>'+ legalCode);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Legal_Type__mdt.'+legalCode);
                    firstMetadataRec.label = legalCode;
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'code__c';
                    customField1.value = jsonObject.get('code');
                    firstMetadataRec.values.add(customField1);
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'code_desc__c';
                    customField2.value = jsonObject.get('code_desc');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'code_group__c';
                    customField3.value = jsonObject.get('code_group');
                    firstMetadataRec.values.add(customField3);
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'code_value__c';
                    customField4.value = jsonObject.get('code_value');
                    firstMetadataRec.values.add(customField4);
                    
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateLegalMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String legalcode = jsonObject.get('code');
                    
                    System.debug('legalCode before update ====>'+legalCode);
                    Legal_Type__mdt ccode = Legal_Type__mdt.getInstance(legalCode);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Legal_Type__mdt.'+ccode.DeveloperName;
                        metadataRec.label = legalCode;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'code__c';
                        customField1.value = jsonObject.get('code');
                        metadataRec.values.add(customField1);
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'code_desc__c';
                        customField2.value = jsonObject.get('code_desc');
                        metadataRec.values.add(customField2);
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'code_group__c';
                        customField3.value = jsonObject.get('code_group');
                        metadataRec.values.add(customField3);
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'code_value__c';
                        customField4.value = jsonObject.get('code_value');
                        metadataRec.values.add(customField4);
                        
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertLegalMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    } 
    */

    // api 5.4 @athar update the product list in custom metadata as per the legacy system reponse.
    
    public static String parseProductJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Product' and PRD_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String Prdmap = JSON.serialize(respMap.get('meta_data'));
                System.debug('prdmap =========>'+Prdmap);
                Map<String, Object> PrdListmap = (Map<String, Object>)JSON.deserializeUntyped(Prdmap);
                System.debug('PrdListmap =======>'+PrdListmap);
                List<Object> PrdList =(List<Object>) PrdListmap.get('prd_list');

                if(PrdList != NULL && PrdList.size()>0){
                    System.debug('============PrdList Size=====================>'+PrdList.size());
                    list<List_Storage__c> PrdListFinal = new list<List_Storage__c>();

                    for(Object Prd : PrdList){
                        Map<String, Object> Prdjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(Prd));
                        System.debug('Prdjsonmap1 ======>'+Prdjsonmap1);

                        if(Prdjsonmap1!= NULL && Prdjsonmap1.size()>0){
                            List_Storage__c lsProduct = new List_Storage__c();
                            lsProduct.PRD_CODE__c = String.valueOf(Prdjsonmap1.get('prd_code'));  
                            lsProduct.PRD_DESC__c = String.valueOf(Prdjsonmap1.get('prd_desc')); 
                            lsProduct.PRD_DESC_HK__c = String.valueOf(Prdjsonmap1.get('prd_desc_hk')); 
                            lsProduct.PRD_Active__c = true;     
                            lsProduct.List_Type__c = 'Product';                  
                            PrdListFinal.add(lsProduct);
                        }
                    }

                    System.debug('Final List of product Inserted ======>'+PrdListFinal);
                    if(PrdListFinal!= null && PrdListFinal.size()>0){
                        insert PrdListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    }

    /*
    public static String parseProductJsonData(String jsonstr){
        // 
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String productMap = JSON.serialize(respMap.get('meta_data'));
                System.debug('productMap ====>'+productMap);
                Map<String, Object> productlistMap = (Map<String, Object>)JSON.deserializeUntyped(productMap);
                System.debug('productlistMap ====>'+productlistMap);
                List<Object> prodList =(List<Object>) productlistMap.get('prd_list');
                if(prodList != NULL && prodList.size()>0){
                    for(Object prod : prodList){
                        System.debug('prod ====>'+prod);
                        System.debug('JSON.serialize(prod) ======>'+JSON.serialize(prod));
                        Map<String, Object> prodjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(prod));
                        System.debug('prodjsonmap1 ======>'+ prodjsonmap1);
                        if(prodjsonmap1!= NULL && prodjsonmap1.size()>0){
                            Map<String, String> prodjsonmap = new Map<String, String> ();
                            for(String key : prodjsonmap1.keySet()){
                                prodjsonmap.put(key, String.valueOf(prodjsonmap1.get(key)));
                            }
                            jsonmapList.add(prodjsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updateProductMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertProductMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String prodCode ='X_' + jsonObject.get('prd_code');
                    System.debug('prodCode before insert ====>'+prodCode);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Product__mdt.'+prodCode);
                    firstMetadataRec.label = prodCode;
                    //adding values to fields
                    // Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    // customField1.field = 'IS_OMBP__c';
                    // customField1.value = jsonObject.get('is_ombp');
                    // firstMetadataRec.values.add(customField1);
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'PRD_CODE__c';
                    customField2.value = jsonObject.get('prd_code');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'PRD_DESC__c';
                    customField3.value = jsonObject.get('prd_desc');
                    firstMetadataRec.values.add(customField3);
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'PRD_DESC_HK__c';
                    customField4.value = jsonObject.get('prd_desc_hk');
                    firstMetadataRec.values.add(customField4);
                    
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateProductMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String prodCode = 'X_' +jsonObject.get('prd_code');
                    System.debug('prodCode before update ====>'+prodCode);
                    Product__mdt ccode = Product__mdt.getInstance(prodCode);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Product__mdt.'+ccode.DeveloperName;
                        metadataRec.label = prodCode;
                        // Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        // customField1.field = 'IS_OMBP__c';
                        // customField1.value = jsonObject.get('is_ombp');
                        // metadataRec.values.add(customField1);
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'PRD_CODE__c';
                        customField2.value = jsonObject.get('prd_code');
                        metadataRec.values.add(customField2);
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'PRD_DESC__c';
                        customField3.value = jsonObject.get('prd_desc');
                        metadataRec.values.add(customField3);
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'PRD_DESC_HK__c';
                        customField4.value = jsonObject.get('prd_desc_hk');
                        metadataRec.values.add(customField4);
                        
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertProductMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */

    // api 5.5 @ update the list of rejection and termination in custom metadata as per the legacy system reponse.

    public static String parseRejTermJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Rejection' and RJ_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String RejTermmap = JSON.serialize(respMap.get('meta_data'));
                System.debug('RejTermmap =========>'+RejTermmap);
                Map<String, Object> RejTermListmap = (Map<String, Object>)JSON.deserializeUntyped(RejTermmap);
                System.debug('RejTermListmap =======>'+RejTermListmap);
                List<Object> RejTermList =(List<Object>) RejTermListmap.get('rj_term_reason_list');

                if(RejTermList != NULL && RejTermList.size()>0){
                    System.debug('============RejTermList Size=====================>'+RejTermList.size());
                    list<List_Storage__c> RejTermListFinal = new list<List_Storage__c>();

                    for(Object RT : RejTermList){
                        Map<String, Object> RTjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(RT));
                        System.debug('RTjsonmap1 ======>'+RTjsonmap1);

                        if(RTjsonmap1 != NULL && RTjsonmap1.size()>0){
                            List_Storage__c lsRejTerm = new List_Storage__c();
                            lsRejTerm.RJ_CODE__c = String.valueOf(RTjsonmap1.get('rj_code'));  
                            lsRejTerm.RJ_DESC__c = String.valueOf(RTjsonmap1.get('rj_desc')); 
                            lsRejTerm.RJ_DESC_HK__c = String.valueOf(RTjsonmap1.get('rj_desc_hk'));
                            lsRejTerm.RJ_REASON_TYPE__c = String.valueOf(RTjsonmap1.get('reason_type'));  
                            lsRejTerm.RJ_USED_BY__c = String.valueOf(RTjsonmap1.get('used_by')); 
                            lsRejTerm.RJ_EFF_DATE__c = date.valueOf(RTjsonmap1.get('eff_date'));  
                            lsRejTerm.RJ_EXP_DATE__c = date.valueOf(RTjsonmap1.get('exp_date'));  
                            lsRejTerm.RJ_Active__c = true;     
                            lsRejTerm.List_Type__c = 'Rejection';                  
                            RejTermListFinal.add(lsRejTerm);
                        }
                    }

                    System.debug('Final List of RejTerm Inserted ======>'+RejTermListFinal);
                    if(RejTermListFinal!= null && RejTermListFinal.size()>0){
                        insert RejTermListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of RejTerm deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    }

    /*
    public static String parseRejTermJsonData(String jsonstr){
        // 
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String rejectMap = JSON.serialize(respMap.get('meta_data'));
                System.debug('rejectMap ====>'+rejectMap);
                Map<String, Object> rejectListMap = (Map<String, Object>)JSON.deserializeUntyped(rejectMap);
                System.debug('rejectListMap ====>'+rejectListMap);
                List<Object> rejectList =(List<Object>) rejectListMap.get('rj_term_reason_list');
                if(rejectList != NULL && rejectList.size()>0){
                    for(Object reject1 : rejectList){
                        System.debug('reject1 ====>'+reject1);
                        System.debug('JSON.serialize(reject1) ======>'+JSON.serialize(reject1));
                        Map<String, Object> rejectjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(reject1));
                        System.debug('rejectjsonmap1 ======>'+ rejectjsonmap1);
                        if(rejectjsonmap1 != NULL && rejectjsonmap1.size()>0){
                            Map<String, String> rejectjsonmap = new Map<String, String> ();
                            for(String key : rejectjsonmap1.keySet()){
                                rejectjsonmap.put(key, String.valueOf(rejectjsonmap1.get(key)));
                            }
                            jsonmapList.add(rejectjsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updateRejTermMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertRejTermMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String rejectCode ='X_'+ jsonObject.get('rj_code');
                    System.debug('rejectCode before insert ====>'+ rejectCode);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Reject_Termination_Reason__mdt.'+rejectCode);
                    firstMetadataRec.label = rejectCode;
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'eff_date__c';
                    customField1.value = (jsonObject.get('eff_date')!= NULL && jsonObject.get('eff_date') != ''?fieldMappingTranslation.string_to_date_format((string)jsonObject.get('eff_date')):NULL);
                    firstMetadataRec.values.add(customField1);
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'exp_date__c';
                    customField2.value = (jsonObject.get('exp_date')!= NULL && jsonObject.get('exp_date') != ''?fieldMappingTranslation.string_to_date_format(jsonObject.get('exp_date')):NULL);
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'reason_type__c';
                    customField3.value = jsonObject.get('reason_type');
                    firstMetadataRec.values.add(customField3);
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'rj_code__c';
                    customField4.value = jsonObject.get('rj_code');
                    firstMetadataRec.values.add(customField4);
                    Metadata.CustomMetadataValue customField5 = new Metadata.CustomMetadataValue();
                    customField5.field = 'rj_desc__c';
                    customField5.value = jsonObject.get('rj_desc');
                    firstMetadataRec.values.add(customField5);
                    Metadata.CustomMetadataValue customField6 = new Metadata.CustomMetadataValue();
                    customField6.field = 'rj_desc_hk__c';
                    customField6.value = jsonObject.get('rj_desc_hk');
                    firstMetadataRec.values.add(customField6);   
                    Metadata.CustomMetadataValue customField7 = new Metadata.CustomMetadataValue();
                    customField7.field = 'use_type__c';
                    customField7.value = jsonObject.get('use_type');
                    firstMetadataRec.values.add(customField7);
                    
                    
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateRejTermMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String rejectCode = 'X_'+jsonObject.get('rj_code__c');
                    
                    System.debug('rejectCode before update ====>'+rejectCode);
                    Reject_Termination_Reason__mdt ccode = Reject_Termination_Reason__mdt.getInstance(rejectCode);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Reject_Termination_Reason__mdt.'+ccode.DeveloperName;
                        metadataRec.label = rejectCode;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'eff_date__c';
                        customField1.value =Date.parse(jsonObject.get('eff_date'));
                        metadataRec.values.add(customField1);
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'exp_date__c';
                        customField2.value = Date.parse(jsonObject.get('exp_date'));
                        metadataRec.values.add(customField2);
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'reason_type__c';
                        customField3.value = jsonObject.get('reason_type');
                        metadataRec.values.add(customField3);
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'rj_code__c';
                        customField4.value = jsonObject.get('rj_code');
                        metadataRec.values.add(customField4);
                        Metadata.CustomMetadataValue customField5 = new Metadata.CustomMetadataValue();
                        customField5.field = 'rj_desc__c';
                        customField5.value = jsonObject.get('rj_desc');
                        metadataRec.values.add(customField5);
                        Metadata.CustomMetadataValue customField6 = new Metadata.CustomMetadataValue();
                        customField6.field = 'rj_desc_hk__c';
                        customField6.value = jsonObject.get('rj_desc_hk');
                        metadataRec.values.add(customField6);
                        Metadata.CustomMetadataValue customField7 = new Metadata.CustomMetadataValue();
                        customField7.field = 'use_type__c';
                        customField7.value = jsonObject.get('use_type');
                        metadataRec.values.add(customField7);
                        
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertRejTermMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */
    
    // api 5.6 update the list of currency in custom metadata as per the legacy system reponse.
    
    public static String parseCurrencyJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Currency' and CurrencyList_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String Currencymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('Currencymap =========>'+Currencymap);
                Map<String, Object> CurrencyListmap = (Map<String, Object>)JSON.deserializeUntyped(Currencymap);
                System.debug('CurrencyListmap =======>'+CurrencyListmap);
                List<Object> CurrencyList =(List<Object>) CurrencyListmap.get('CCY_LIST');

                if(CurrencyList != NULL && CurrencyList.size()>0){
                    System.debug('============countryList Size=====================>'+CurrencyList.size());
                    list<List_Storage__c> CurrencyListFinal = new list<List_Storage__c>();

                    for(Object cr : CurrencyList){
                        Map<String, Object> currjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cr));
                        System.debug('ctryjsonmap1 ======>'+currjsonmap1);

                        if(currjsonmap1!= NULL && currjsonmap1.size()>0){
                            List_Storage__c lsCurrency = new List_Storage__c();
                            lsCurrency.CurrencyList_Currency_Code__c = String.valueOf(currjsonmap1.get('CUR_CODE'));  
                            lsCurrency.CurrencyList_Currency_Desc__c = String.valueOf(currjsonmap1.get('CUR_DESC')); 
                            lsCurrency.CurrencyList_Currency_Desc_HK__c = String.valueOf(currjsonmap1.get('CUR_DESC_HK'));     
                            lsCurrency.CurrencyList_Sorting_Seq__c = Integer.valueOf(currjsonmap1.get('SORT_SEQ'));
                            lsCurrency.CurrencyList_Active__c = true;     
                            lsCurrency.List_Type__c	 = 'Currency';                  
                            CurrencyListFinal.add(lsCurrency);
                        }
                    }

                    System.debug('Final List of Country Inserted ======>'+CurrencyListFinal);
                    if(CurrencyListFinal!= null && CurrencyListFinal.size()>0){
                        insert CurrencyListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    }  

    /*
    public static String parseCurrencyJsonData(String jsonstr){
        // 
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String currencyTypeMap = JSON.serialize(respMap.get('meta_data'));
                System.debug('currencyTypeMap ====>'+currencyTypeMap);
                Map<String, Object> currencyListMap = (Map<String, Object>)JSON.deserializeUntyped(currencyTypeMap);
                System.debug('currencyListMap ====>'+currencyListMap);
                List<Object> currencyList =(List<Object>) currencyListMap.get('ccy_list');
                if(currencyList != NULL && currencyList.size()>0){
                    for(Object currency1 : currencyList){
                        System.debug('currency1 ====>'+currency1);
                        System.debug('JSON.serialize(currency1) ======>'+JSON.serialize(currency1));
                        Map<String, Object> currencyjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(currency1));
                        System.debug('currencyjsonmap1 ======>'+ currencyjsonmap1);
                        if(currencyjsonmap1 != NULL && currencyjsonmap1.size()>0){
                            Map<String, String> currencyjsonmap = new Map<String, String> ();
                            for(String key : currencyjsonmap1.keySet()){
                                currencyjsonmap.put(key, String.valueOf(currencyjsonmap1.get(key)));
                            }
                            jsonmapList.add(currencyjsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updateCurrencyMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertCurrencyMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String currencyCode = jsonObject.get('cur_code');
                    System.debug('currencyCode before insert ====>'+ currencyCode);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Currency__mdt.'+currencyCode);
                    firstMetadataRec.label = currencyCode;
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'cur_code__c';
                    customField1.value = jsonObject.get('cur_code');
                    firstMetadataRec.values.add(customField1);
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'cur_desc__c';
                    customField2.value = jsonObject.get('cur_desc');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'cur_desc_hk__c';
                    customField3.value = jsonObject.get('cur_desc_hk');
                    firstMetadataRec.values.add(customField3);
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'sort_seq__c';
                    customField4.value = jsonObject.get('sort_seq');
                    firstMetadataRec.values.add(customField4);
                    
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateCurrencyMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String currencyCode = jsonObject.get('cur_code');
                    
                    System.debug('currencyCode before update ====>'+currencyCode);
                    Currency__mdt ccode = Currency__mdt.getInstance(currencyCode);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Currency__mdt.'+ccode.DeveloperName;
                        metadataRec.label = currencyCode;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'cur_code__c';
                        customField1.value = jsonObject.get('cur_code');
                        metadataRec.values.add(customField1);
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'cur_desc__c';
                        customField2.value = jsonObject.get('cur_desc');
                        metadataRec.values.add(customField2);
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'cur_desc_hk__c';
                        customField3.value = jsonObject.get('cur_desc_hk');
                        metadataRec.values.add(customField3);
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'sort_seq__c';
                        customField4.value = jsonObject.get('sort_seq');
                        metadataRec.values.add(customField4);
                        
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertCurrencyMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */
    
    // api 5.7 @athar update the payment method type list in custom metadata as per the legacy system reponse.
    
    public static String parsePaymentMethodJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Payment Method' and PAYM_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String PAYMmap = JSON.serialize(respMap.get('meta_data'));
                System.debug('PAYMmap =========>'+PAYMmap);
                Map<String, Object> PAYMListmap = (Map<String, Object>)JSON.deserializeUntyped(PAYMmap);
                System.debug('PAYMListmap =======>'+PAYMListmap);
                List<Object> PAYMList =(List<Object>) PAYMListmap.get('pay_method_list');

                if(PAYMList != NULL && PAYMList.size()>0){
                    System.debug('============countryList Size=====================>'+PAYMList.size());
                    list<List_Storage__c> PAYMListFinal = new list<List_Storage__c>();

                    for(Object p : PAYMList){
                        Map<String, Object> PAYMjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(p));
                        System.debug('PAYMjsonmap1 ======>'+PAYMjsonmap1);

                        if(PAYMjsonmap1!= NULL && PAYMjsonmap1.size()>0){
                            List_Storage__c lsPAYM = new List_Storage__c();
                            lsPAYM.PAYM_CODE_GROUP__c = String.valueOf(PAYMjsonmap1.get('code_group'));  
                            lsPAYM.PAYM_CODE__c = String.valueOf(PAYMjsonmap1.get('code')); 
                            lsPAYM.PAYM_CODE_VALUE__c = String.valueOf(PAYMjsonmap1.get('code_value'));     
                            lsPAYM.PAYM_CODE_DESC__c = String.valueOf(PAYMjsonmap1.get('code_desc'));
                            lsPAYM.PAYM_Active__c = true;     
                            lsPAYM.List_Type__c	 = 'Payment Method';                  
                            PAYMListFinal.add(lsPAYM);
                        }
                    }

                    System.debug('Final List of payment method Inserted ======>'+PAYMListFinal);
                    if(PAYMListFinal!= null && PAYMListFinal.size()>0){
                        insert PAYMListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of payment method ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    } 

    /*
    public static String parsePaymentMethodJsonData(String jsonstr){
        // 
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String paymentTypeMap = JSON.serialize(respMap.get('meta_data'));
                System.debug('paymentTypeMap ====>'+paymentTypeMap);
                Map<String, Object> paymenttypelistMap = (Map<String, Object>)JSON.deserializeUntyped(paymentTypeMap);
                System.debug('paymenttypelistMap ====>'+paymenttypelistMap);
                List<Object> payMethodList =(List<Object>) paymenttypelistMap.get('pay_method_list');
                if(payMethodList != NULL && payMethodList.size()>0){
                    for(Object paymethod : payMethodList){
                        System.debug('paymethod ====>'+paymethod);
                        System.debug('JSON.serialize(paymethod) ======>'+JSON.serialize(paymethod));
                        Map<String, Object> paymethodjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(paymethod));
                        System.debug('paymethodjsonmap1 ======>'+ paymethodjsonmap1);
                        if(paymethodjsonmap1 != NULL && paymethodjsonmap1.size()>0){
                            Map<String, String> payMethodjsonmap = new Map<String, String> ();
                            for(String key : paymethodjsonmap1.keySet()){
                                payMethodjsonmap.put(key, String.valueOf(paymethodjsonmap1.get(key)));
                            }
                            jsonmapList.add(payMethodjsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updatePayMethodMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertPayMethodMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String paymethodCode = jsonObject.get('code');
                    System.debug('paymethodCode before insert ====>'+ paymethodCode);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Payment_Method__mdt.'+paymethodCode);
                    firstMetadataRec.label = paymethodCode;
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'code__c';
                    customField1.value = jsonObject.get('code');
                    firstMetadataRec.values.add(customField1);
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'code_desc__c';
                    customField2.value = jsonObject.get('code_desc');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'code_group__c';
                    customField3.value = jsonObject.get('code_group');
                    firstMetadataRec.values.add(customField3);
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'code_value__c';
                    customField4.value = jsonObject.get('code_value');
                    firstMetadataRec.values.add(customField4);
                    
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updatePayMethodMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String paymentcode = jsonObject.get('code');
                    
                    System.debug('paymentCode before update ====>'+paymentCode);
                    Payment_Method__mdt ccode = Payment_Method__mdt.getInstance(paymentCode);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Payment_Method__mdt.'+ccode.DeveloperName;
                        metadataRec.label = paymentCode;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'code__c';
                        customField1.value = jsonObject.get('code');
                        metadataRec.values.add(customField1);
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'code_desc__c';
                        customField2.value = jsonObject.get('code_desc');
                        metadataRec.values.add(customField2);
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'code_group__c';
                        customField3.value = jsonObject.get('code_group');
                        metadataRec.values.add(customField3);
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'code_value__c';
                        customField4.value = jsonObject.get('code_value');
                        metadataRec.values.add(customField4);
                        
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertPayMethodMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }

    */

    // api 5.8 @athar  update the master list of origin country type list in custom metadata as per the legacy system reponse.
    
    public static String parseOriginCtryJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Origin Country' and OrgCtryList_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String countrymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('countrymap =========>'+countrymap);
                Map<String, Object> countrylistmap = (Map<String, Object>)JSON.deserializeUntyped(countrymap);
                System.debug('countrylistmap =======>'+countrylistmap);
                List<Object> countryList =(List<Object>) countrylistmap.get('ctry_list');

                if(countryList != NULL && countryList.size()>0){
                    System.debug('============countryList Size=====================>'+countryList.size());
                    list<List_Storage__c> countryListFinal = new list<List_Storage__c>();

                    for(Object cntry : countryList){
                        Map<String, Object> ctryjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cntry));
                        System.debug('ctryjsonmap1 ======>'+ctryjsonmap1);

                        if(ctryjsonmap1!= NULL && ctryjsonmap1.size()>0){
                            List_Storage__c lsCountry = new List_Storage__c();
                            lsCountry.OrgCtryList_Country_Code__c = String.valueOf(ctryjsonmap1.get('ctry_code'));  
                            lsCountry.OrgCtryList_Country_Name__c = String.valueOf(ctryjsonmap1.get('ctry_name')); 
                            lsCountry.OrgCtryList_Country_Name_HK__c = String.valueOf(ctryjsonmap1.get('ctry_name_hk'));     
                            lsCountry.OrgCtryList_Active__c	 = true;     
                            lsCountry.List_Type__c	 = 'Origin Country';                  
                            countryListFinal.add(lsCountry);
                        }
                    }

                    System.debug('Final List of Country Inserted ======>'+countryListFinal);
                    if(countryListFinal!= null && countryListFinal.size()>0){
                        insert countryListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    }    
    
    /*
    public static String insertOriginCtryMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String cntryname1 = jsonObject.get('ctry_name');
                    String cntryname2 = cntryname1.trim();
                    String cntryname3 = cntryname2.remove('(');
                    String cntryname4 = cntryname3.remove(')');
                    String cntryname5 = cntryname4.remove('\'');
                    String cntryname6 = cntryname5.remove(',');
                    String cntryname71 = cntryname6.remove('-');
                    String cntryname7 = cntryname71.remove('.');
                    String cntryname8 = ((cntryname7 != NULl && cntryname7.length()>=40)?cntryname7.substring(0, 39):cntryname7).trim();
                    String cntryname = cntryname8.replace(' ', '_');
                    System.debug('cntryname before insert ====>'+cntryname);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Origin_Country__mdt.'+cntryname).removeEnd('_');
                    firstMetadataRec.label = ((cntryname2 != NULL && cntryname2.length()>=40)?cntryname2.substring(0,39):cntryname2).trim(); //jsonObject.get('ctry_name');   // cntryname;    
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'ctry_code__c';
                    customField1.value = jsonObject.get('ctry_code');
                    firstMetadataRec.values.add(customField1);     
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'ctry_name_hk__c';
                    customField2.value = jsonObject.get('ctry_name_hk');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'ctry_name__c';
                    customField3.value = jsonObject.get('ctry_name');
                    firstMetadataRec.values.add(customField3);  
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateOriginCtryMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String cntryname1 = jsonObject.get('ctry_name');
                    String cntryname2 = cntryname1.trim();
                    String cntryname3 = cntryname2.remove('(');
                    String cntryname4 = cntryname3.remove(')');
                    String cntryname5 = cntryname4.remove('\'');
                    String cntryname6 = cntryname5.remove(',');
                    String cntryname71 = cntryname6.remove('-');
                    String cntryname7 = cntryname71.remove('.');
                    String cntryname8 = ((cntryname7 != NULl && cntryname7.length()>=40)?cntryname7.substring(0, 39):cntryname7).trim();
                    String cntryname = cntryname8.replace(' ', '_');
                    System.debug('cntryname before update ====>'+cntryname);
                    Origin_Country__mdt ccode = Origin_Country__mdt.getInstance(cntryname);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Origin_Country__mdt.'+ccode.DeveloperName;
                        metadataRec.label = ((cntryname2 != NULL && cntryname2.length()>=40)?cntryname2.substring(0,39):cntryname2).trim();    // ccode.MasterLabel;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'ctry_code__c';
                        customField1.value = jsonObject.get('ctry_code');
                        metadataRec.values.add(customField1);     
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'ctry_name_hk__c';
                        customField2.value = jsonObject.get('ctry_name_hk');
                        metadataRec.values.add(customField2);  
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'ctry_name__c';
                        customField3.value = jsonObject.get('ctry_name');
                        metadataRec.values.add(customField3); 
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertOriginCtryMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */

    // api 5.9 @athar update the master list of destination country type list in custom metadata as per the legacy system reponse.
    
    public static String parseDestCtryJsonData(String jsonstr){
        
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Destination Country' and DestCtryList_Active__c = true]); 
            System.debug('respMap =========>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String countrymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('countrymap ====>'+countrymap);
                Map<String, Object> countrylistmap = (Map<String, Object>)JSON.deserializeUntyped(countrymap);
                System.debug('countrylistmap ====>'+countrylistmap);
                List<Object> countryList =(List<Object>) countrylistmap.get('ctry_list');
                // ----------------------------------------

                System.debug('============countryList Size=====================>'+countryList.size());
                    list<List_Storage__c> DcountryListFinal = new list<List_Storage__c>();
                
                if(countryList != NULL && countryList.size()>0){
                    for(Object cntry : countryList){
                        Map<String, Object> ctryjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cntry));
                        System.debug('ctryjsonmap1 ======>'+ctryjsonmap1);
                        
                        if(ctryjsonmap1!= NULL && ctryjsonmap1.size()>0){
                            List_Storage__c lsCountry = new List_Storage__c();
                            lsCountry.DestCtryList_Country_Code__c = String.valueOf(ctryjsonmap1.get('ctry_code'));  
                            lsCountry.DestCtryList_Country_Name__c = String.valueOf(ctryjsonmap1.get('ctry_name')); 
                            lsCountry.DestCtryList_Country_Name_HK__c = String.valueOf(ctryjsonmap1.get('ctry_name_hk'));     
                            lsCountry.DestCtryList_Policy_Type__c = String.valueOf(ctryjsonmap1.get('pcy_type'));
                            lsCountry.DestCtryList_Active__c = true;     
                            lsCountry.List_Type__c	 = 'Destination Country';                  
                            DcountryListFinal.add(lsCountry);
                        }
                    }
                    
                    System.debug('Final List of Country Inserted ======>'+DcountryListFinal);
                    if(DcountryListFinal!= null && DcountryListFinal.size()>0){
                        insert DcountryListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    
    /*
    public static String parseDestCtryJsonData(String jsonstr){
        // sample json
        // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"ctry_list":[{"ctry_code":"ABW","ctry_name":"ARUBA","ctry_name_hk":"阿魯巴島"},............. continue
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String countrymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('countrymap ====>'+countrymap);
                Map<String, Object> countrylistmap = (Map<String, Object>)JSON.deserializeUntyped(countrymap);
                System.debug('countrylistmap ====>'+countrylistmap);
                List<Object> countryList =(List<Object>) countrylistmap.get('ctry_list');
                if(countryList != NULL && countryList.size()>0){
                    for(Object cntry : countryList){
                        System.debug('cntry ======>'+cntry);
                        System.debug('JSON.serialize(cntry) ======>'+JSON.serialize(cntry));
                        Map<String, Object> ctryjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cntry));
                        System.debug('ctryjsonmap1 ======>'+ctryjsonmap1);
                        if(ctryjsonmap1!= NULL && ctryjsonmap1.size()>0){
                            Map<String, String> ctryjsonmap = new Map<String, String> ();
                            for(String key : ctryjsonmap1.keySet()){
                                ctryjsonmap.put(key, String.valueOf(ctryjsonmap1.get(key)));
                            }
                            jsonmapList.add(ctryjsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updateDestCtryMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertDestCtryMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String cntryname1 = jsonObject.get('ctry_name');
                    String cntryname2 = cntryname1.trim();
                    String cntryname3 = cntryname2.remove('(');
                    String cntryname4 = cntryname3.remove(')');
                    String cntryname5 = cntryname4.remove('\'');
                    String cntryname6 = cntryname5.remove(',');
                    String cntryname71 = cntryname6.remove('-');
                    String cntryname7 = cntryname71.remove('.');
                    String cntryname8 = ((cntryname7 != NULl && cntryname7.length()>=40)?cntryname7.substring(0, 39):cntryname7).trim();
                    String cntryname = cntryname8.replace(' ', '_');
                    System.debug('cntryname before insert ====>'+cntryname);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Origin_Country__mdt.'+cntryname).removeEnd('_');
                    firstMetadataRec.label = ((cntryname2 != NULL && cntryname2.length()>=40)?cntryname2.substring(0,39):cntryname2).trim(); //jsonObject.get('ctry_name');   // cntryname;    
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'ctry_code__c';
                    customField1.value = jsonObject.get('ctry_code');
                    firstMetadataRec.values.add(customField1);     
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'ctry_name_hk__c';
                    customField2.value = jsonObject.get('ctry_name_hk');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'ctry_name__c';
                    customField3.value = jsonObject.get('ctry_name');
                    firstMetadataRec.values.add(customField3);  
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updateDestCtryMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String cntryname1 = jsonObject.get('ctry_name');
                    String cntryname2 = cntryname1.trim();
                    String cntryname3 = cntryname2.remove('(');
                    String cntryname4 = cntryname3.remove(')');
                    String cntryname5 = cntryname4.remove('\'');
                    String cntryname6 = cntryname5.remove(',');
                    String cntryname71 = cntryname6.remove('-');
                    String cntryname7 = cntryname71.remove('.');
                    String cntryname8 = ((cntryname7 != NULl && cntryname7.length()>=40)?cntryname7.substring(0, 39):cntryname7).trim();
                    String cntryname = cntryname8.replace(' ', '_');
                    System.debug('cntryname before update ====>'+cntryname);
                    Origin_Country__mdt ccode = Origin_Country__mdt.getInstance(cntryname);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Origin_Country__mdt.'+ccode.DeveloperName;
                        metadataRec.label = ((cntryname2 != NULL && cntryname2.length()>=40)?cntryname2.substring(0,39):cntryname2).trim();    // ccode.MasterLabel;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'ctry_code__c';
                        customField1.value = jsonObject.get('ctry_code');
                        metadataRec.values.add(customField1);     
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'ctry_name_hk__c';
                        customField2.value = jsonObject.get('ctry_name_hk');
                        metadataRec.values.add(customField2);  
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'ctry_name__c';
                        customField3.value = jsonObject.get('ctry_name');
                        metadataRec.values.add(customField3); 
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertDestCtryMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */
    
    // api 5.10 @athar update the master list of Port of Loading type list as per the legacy system reponse.
    
    public static String parsePortOfLdgJsonData(String jsonstr){
        
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Port of Loading' and 	PortOfLdg_Active__c = true]); 
            System.debug('respMap =========>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String countrymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('countrymap ====>'+countrymap);
                Map<String, Object> countrylistmap = (Map<String, Object>)JSON.deserializeUntyped(countrymap);
                System.debug('countrylistmap ====>'+countrylistmap);
                List<Object> countryList =(List<Object>) countrylistmap.get('ctry_list');
                // ----------------------------------------

                System.debug('============countryList Size=====================>'+countryList.size());
                    list<List_Storage__c> PLcountryListFinal = new list<List_Storage__c>();
                
                if(countryList != NULL && countryList.size()>0){
                    for(Object cntry : countryList){
                        Map<String, Object> ctryjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cntry));
                        System.debug('ctryjsonmap1 ======>'+ctryjsonmap1);
                        
                        if(ctryjsonmap1!= NULL && ctryjsonmap1.size()>0){
                            List_Storage__c lsCountry = new List_Storage__c();
                            lsCountry.PortOfLdg_Country_Code__c = String.valueOf(ctryjsonmap1.get('ctry_code'));  
                            lsCountry.PortOfLdg_Country_Name__c = String.valueOf(ctryjsonmap1.get('ctry_name')); 
                            lsCountry.PortOfLdg_Country_Name_HK__c = String.valueOf(ctryjsonmap1.get('ctry_name_hk'));     
                            lsCountry.PortOfLdg_Policy_Type__c = String.valueOf(ctryjsonmap1.get('pcy_type'));
                            lsCountry.PortOfLdg_Active__c = true;     
                            lsCountry.List_Type__c	 = 'Port of Loading';                  
                            PLcountryListFinal.add(lsCountry);
                        }
                    }
                    
                    System.debug('Final List of Country Inserted ======>'+PLcountryListFinal);
                    if(PLcountryListFinal!= null && PLcountryListFinal.size()>0){
                        insert PLcountryListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }

    // api 5.12 @athar update the master list of buyer country type list as per the legacy system reponse.
    
    public static String parseByrCtryJsonData(String jsonstr){
        
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Buyer Country' and ByrCtry_Active__c = true]); 
            System.debug('respMap =========>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String countrymap = JSON.serialize(respMap.get('meta_data'));
                System.debug('countrymap ====>'+countrymap);
                Map<String, Object> countrylistmap = (Map<String, Object>)JSON.deserializeUntyped(countrymap);
                System.debug('countrylistmap ====>'+countrylistmap);
                List<Object> countryList =(List<Object>) countrylistmap.get('ctry_list');
                // ----------------------------------------

                System.debug('============countryList Size=====================>'+countryList.size());
                    list<List_Storage__c> BcountryListFinal = new list<List_Storage__c>();
                
                if(countryList != NULL && countryList.size()>0){
                    for(Object cntry : countryList){
                        Map<String, Object> ctryjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cntry));
                        System.debug('ctryjsonmap1 ======>'+ctryjsonmap1);
                        
                        if(ctryjsonmap1!= NULL && ctryjsonmap1.size()>0){
                            List_Storage__c lsCountry = new List_Storage__c();
                            lsCountry.ByrCtry_Country_Code__c = String.valueOf(ctryjsonmap1.get('ctry_code'));  
                            lsCountry.ByrCtry_Country_Name__c = String.valueOf(ctryjsonmap1.get('ctry_name')); 
                            lsCountry.ByrCtry_Country_Name_HK__c = String.valueOf(ctryjsonmap1.get('ctry_name_hk'));     
                            lsCountry.ByrCtry_Policy_Type__c = String.valueOf(ctryjsonmap1.get('pcy_type'));
                            lsCountry.ByrCtry_Active__c = true;     
                            lsCountry.List_Type__c	 = 'Buyer Country';                  
                            BcountryListFinal.add(lsCountry);
                        }
                    }
                    
                    System.debug('Final List of Country Inserted ======>'+BcountryListFinal);
                    if(BcountryListFinal!= null && BcountryListFinal.size()>0){
                        insert BcountryListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }

    // api 5.14  Get the master list of Proposal Refer List

    public static String parsePropReferListJsonData(String jsonstr){
        
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Proposal Refer List' and Proposal_Refer_Active__c = true]); 
            System.debug('respMap =========>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String PropRefermap = JSON.serialize(respMap.get('meta_data'));
                System.debug('PropRefermap ====>'+PropRefermap);
                Map<String, Object> PropRefelistrmap = (Map<String, Object>)JSON.deserializeUntyped(PropRefermap);
                System.debug('PropRefelistrmap ====>'+PropRefelistrmap);
                List<Object> PropRefelist =(List<Object>) PropRefelistrmap.get('code_list');
                // ----------------------------------------

                System.debug('============PropRefelist Size=====================>'+PropRefelist.size());
                    list<List_Storage__c> PropRefelistFinal = new list<List_Storage__c>();
                
                if(PropRefelist != NULL && PropRefelist.size()>0){
                    for(Object Prop : PropRefelist){
                        Map<String, Object> Propjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(Prop));
                        System.debug('Propjsonmap1 ======>'+Propjsonmap1);
                        
                        if(Propjsonmap1!= NULL && Propjsonmap1.size()>0){
                            List_Storage__c lsProp = new List_Storage__c();
                            lsProp.ProRefer_CODE__c = String.valueOf(Propjsonmap1.get('code'));  
                            lsProp.ProRefer_CODE_GROUP__c = String.valueOf(Propjsonmap1.get('code_group')); 
                            lsProp.ProRefer_CODE_VALUE__c = String.valueOf(Propjsonmap1.get('code_value'));     
                            lsProp.ProRefer_CODE_DESC__c = String.valueOf(Propjsonmap1.get('code_desc'));
                            lsProp.Proposal_Refer_Active__c = true;     
                            lsProp.List_Type__c	 = 'Proposal Refer List';                  
                            PropRefelistFinal.add(lsProp);
                        }
                    }
                    
                    System.debug('Final List of Proposal Inserted ======>'+PropRefelistFinal);
                    if(PropRefelistFinal!= null && PropRefelistFinal.size()>0){
                        insert PropRefelistFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    
    /*
    public static String parsePropReferListJsonData(String jsonstr){
        // sample json  
        // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"code_list":
        // [{"code_group":"SRC_MST","code":"TARP","code_value":"Trade Association Referral Programme","code_desc":"Trade Association Referral Programme"},
        // {"code_group":"SRC_MST","code":"MGM","code_value":"Policyholder Referral ............. continue
        try{
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            List< Map <String, String>> jsonmapList = new List< Map <String, String>>();
            System.debug('respMap ====>'+respMap);
            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') ====>'+respMap.get('meta_data'));
                String codelist = JSON.serialize(respMap.get('meta_data'));
                System.debug('codelist ====>'+codelist);
                Map<String, Object> codelistmap = (Map<String, Object>)JSON.deserializeUntyped(codelist);
                System.debug('codelistmap ====>'+codelistmap);
                List<Object> code_List =(List<Object>) codelistmap.get('code_list');
                if(code_List != NULL && code_List.size()>0){
                    for(Object code1 : code_List){
                        System.debug('code1 ======>'+code1);
                        System.debug('JSON.serialize(code1) ======>'+JSON.serialize(code1));
                        Map<String, Object> codejsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(code1));
                        System.debug('codejsonmap1 ======>'+codejsonmap1);
                        if(codejsonmap1!= NULL && codejsonmap1.size()>0){
                            Map<String, String> codejsonmap = new Map<String, String> ();
                            for(String key : codejsonmap1.keySet()){
                                codejsonmap.put(key, String.valueOf(codejsonmap1.get(key)));
                            }
                            jsonmapList.add(codejsonmap);
                        }
                    }
                }
            }

            System.debug('jsonmapList before update or insert ====>'+jsonmapList);
            if(jsonmapList != NULL && jsonmapList.size()>0){
                String jobid = UpdateMasterListCustomMetadata.updatePropReferListMetadata(jsonmapList);
                return 'job placed in queue with id '+jobid;
            }
        }
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;
    }
    public static String insertPropReferListMetadata(List<Map<String, String>> jsonmapList){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.     
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String,String> jsonObject : jsonmapList){
                    Metadata.CustomMetadata firstMetadataRec =  new Metadata.CustomMetadata();
                    String codename1 = jsonObject.get('code_group')+'_'+jsonObject.get('code');
                    String codename2 = codename1.trim();
                    String codename3 = codename2.remove('(');
                    String codename4 = codename3.remove(')');
                    String codename5 = codename4.remove('\'');
                    String codename6 = codename5.remove(',');
                    String codename71 = codename6.remove('-');
                    String codename7 = codename71.remove('.');
                    String codename8 = ((codename7 != NULl && codename7.length()>=40)?codename7.substring(0, 39):codename7).trim();
                    String codename = codename8.replace(' ', '_');
                    System.debug('codename before insert ====>'+codename);
                    firstMetadataRec.fullName = (nameSpacePrefix + 'Proposal_Referral_List__mdt.'+codename).removeEnd('_');
                    firstMetadataRec.label = ((codename2 != NULL && codename2.length()>=40)?codename2.substring(0,39):codename2).trim(); //jsonObject.get('ctry_name');   // cntryname;    
                    //adding values to fields
                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                    customField1.field = 'code_group__c';
                    customField1.value = jsonObject.get('code_group');
                    firstMetadataRec.values.add(customField1);     
                    Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                    customField2.field = 'code__c';
                    customField2.value = jsonObject.get('code');
                    firstMetadataRec.values.add(customField2);   
                    Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                    customField3.field = 'code_value__c';
                    customField3.value = jsonObject.get('code_value');
                    firstMetadataRec.values.add(customField3);
                    Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                    customField4.field = 'code_desc__c';
                    customField4.value = jsonObject.get('code_desc');
                    firstMetadataRec.values.add(customField4);  
                    mdContainer.addMetadata(firstMetadataRec);   //adding record container that will be used to deploy the records in custom metadata.
                    System.debug('firstMetadataRec ====>'+firstMetadataRec);
                }
            }           
                      
            System.debug('mdContainer ====>'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId ====>'+jobId);
                return jobId;
            }
            else{
                return 'container is null.';
            }
        }
        catch(Exception ex){             
            //System.assert(false,ex.getMessage()); 
            System.debug('Exception ex ====>'+ex.getMessage()+'==>'+ex.getLineNumber());
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();
        }
        // return NULL;
    }
    public static String updatePropReferListMetadata(List< Map <String, String>> jsonmapList){
        try{
            List<Map<String, String>> jsoninsertMaplist = new List<Map<String, String>>();
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if(jsonmapList != NULL && jsonmapList.size()>0){
                for(Map<String, String> jsonObject : jsonmapList){
                    String codename1 = jsonObject.get('code_group')+'_'+jsonObject.get('code');
                    String codename2 = codename1.trim();
                    String codename3 = codename2.remove('(');
                    String codename4 = codename3.remove(')');
                    String codename5 = codename4.remove('\'');
                    String codename6 = codename5.remove(',');
                    String codename71 = codename6.remove('-');
                    String codename7 = codename71.remove('.');
                    String codename8 = ((codename7 != NULl && codename7.length()>=40)?codename7.substring(0, 39):codename7).trim();
                    String codename = codename8.replace(' ', '_');
                    System.debug('codename before insert ====>'+codename);
                    Proposal_Referral_List__mdt ccode = Proposal_Referral_List__mdt.getInstance(codename);
                    System.debug('ccode ====>'+ccode);
                    if(ccode!= NULL){
                        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                        metadataRec.fullName = 'Proposal_Referral_List__mdt.'+ccode.DeveloperName;
                        metadataRec.label = ((codename2 != NULL && codename2.length()>=40)?codename2.substring(0,39):codename2).trim();    // ccode.MasterLabel;
                        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                        customField1.field = 'code_group__c';
                        customField1.value = jsonObject.get('code_group');
                        metadataRec.values.add(customField1);     
                        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                        customField2.field = 'code__c';
                        customField2.value = jsonObject.get('code');
                        metadataRec.values.add(customField2);  
                        Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                        customField3.field = 'code_value__c';
                        customField3.value = jsonObject.get('code_value');
                        metadataRec.values.add(customField3); 
                        Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                        customField4.field = 'code_value__c';
                        customField4.value = jsonObject.get('code_desc');
                        metadataRec.values.add(customField4); 
                        mdContainer.addMetadata(metadataRec);
                        System.debug('metadataRec ====>'+metadataRec);
                    }
                    else{
                        jsoninsertMaplist.add(jsonObject);
                        System.debug('added in json insert map. ====>');
                    }
                }
                
                System.debug('mdContainer ====>'+mdContainer);  
            }       
            String jobid2;
            if (jsoninsertMaplist !=NULL && jsoninsertMaplist.size()>0){
                jobid2 = UpdateMasterListCustomMetadata.insertPropReferListMetadata(jsoninsertMaplist);
            }
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(mdContainer != NULL && JSON.serialize(mdContainer).length()>4){
                String jobId1 = Metadata.Operations.enqueueDeployment(mdContainer, null);
                System.debug('jobId1 ====>'+jobId1);    
                jobId1 = (jobId1!=NULL && jobId1 != ''?jobId1 +' and '+jobid2:jobid2);
                return jobId1;                          
            }
            else{
                return 'container is null.';
            }
        }
        catch(exception ex){
            System.debug('exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber());         
            return 'exception ====>'+ex.getMessage()+ '==>'+ex.getLineNumber();                        
        }    
        // return NULL;   
    }
    */

    // api 5.15 @athar Get master list of industry 

    /*
    public static String parseIndustryJsonData(String jsonstr){
        try{

            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            list<List_Storage__c> existingList = new list<List_Storage__c>([Select id from List_Storage__c 
                                where List_Type__c = 'Legal Type' and CurrencyList_Active__c = true]); 
            System.debug('respMap =========>'+respMap);

            if(respMap != NULL && respMap.size() >0 && respMap.containsKey('meta_data')){
                System.debug('respMap.get(\'meta_data\') =========>'+respMap.get('meta_data'));
                String LegalTypemap = JSON.serialize(respMap.get('meta_data'));
                System.debug('LegalTypemap =========>'+LegalTypemap);
                Map<String, Object> LegalTypeListmap = (Map<String, Object>)JSON.deserializeUntyped(LegalTypemap);
                System.debug('LegalTypeListmap =======>'+LegalTypeListmap);
                List<Object> LegalTypeList =(List<Object>) LegalTypeListmap.get('LEGAL_TYPE_LIST');

                if(LegalTypeList != NULL && LegalTypeList.size()>0){
                    System.debug('============LegalTypeList Size=====================>'+LegalTypeList.size());
                    list<List_Storage__c> LegalTypeListFinal = new list<List_Storage__c>();

                    for(Object lt : LegalTypeList){
                        Map<String, Object> ltjsonmap1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(lt));
                        System.debug('ltjsonmap1 ======>'+ltjsonmap1);

                        if(ltjsonmap1!= NULL && ltjsonmap1.size()>0){
                            List_Storage__c lsLegal = new List_Storage__c();
                            lsLegal.LegalList_Code_Group__c = String.valueOf(ltjsonmap1.get('CODE_GROUP'));  
                            lsLegal.LegalList_Code__c = String.valueOf(ltjsonmap1.get('CODE')); 
                            lsLegal.LegalList_Code_Value__c = String.valueOf(ltjsonmap1.get('CODE_VALUE'));     
                            lsLegal.LegalList_Code_Desc__c = String.valueOf(ltjsonmap1.get('CODE_DESC'));
                            lsLegal.LegalList_Active__c = true;     
                            lsLegal.List_Type__c = 'Legal Type';                  
                            LegalTypeListFinal.add(lsLegal);
                        }
                    }

                    System.debug('Final List of Legal Inserted ======>'+LegalTypeListFinal);
                    if(LegalTypeListFinal!= null && LegalTypeListFinal.size()>0){
                        insert LegalTypeListFinal;
                        // Delete existing old list
                        if(existingList != null && existingList.size()>0)
                        {
                            System.debug('delete list size==>'+existingList.size()+'Existing List of Country deleted ======>'+existingList);
                            delete existingList;
                        }                        
                    }
                }                
            }
        }    
        catch(Exception e){
            System.debug('Exception e ====>'+e.getMessage()+'==>Line number ==>'+e.getLineNumber()+
                    '==> stack trace ==>'+e.getStackTraceString());
            return e.getMessage();
        }
        return NULL;        

    } 

    */
    
}