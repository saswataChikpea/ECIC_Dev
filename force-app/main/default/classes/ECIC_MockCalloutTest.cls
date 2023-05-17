/*---------------------------------------------------
    Desc : Mock call out class for http callout test coverage purposes
    created by : sayantan@chikpea.com
    created date : 28-Jul-2021
    Modified on : 2-Aug-2021
-----------------------------------------------------*/
@isTest
global class ECIC_MockCalloutTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://api-uat.ec-reach.com.hk:9444', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        if(req.getEndpoint().containsIgnoreCase('https://api-uat.ec-reach.com.hk:9444/api/services/oauth2/token')){
            // access token callout test case.
            res.setBody('{"access_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyMFhGYkt'+
                'XemJad2tya0p3Tm1zRVJXb0xNSVVsckhnUllCbUloTDVGTHBRIn0.eyJleHAiOjE2Mjc1NjMxNTMsImlhdCI6MTYyNzQ3Njc'+
                '1MywianRpIjoiMmJmYTQ4NzUtMWZmYS00M2Y3LWJhY2ItZWQ1NjVjNTliODkxIiwiaXNzIjoiaHR0cDovL2tjL2F1dGgvcmVhbG1z'+
                'L0RlbW8tUmVhbG0iLCJzdWIiOiIyZmM4YmVlYy00NjMyLTQyODQtYTc0NS0xNTQyMDczZDBlMzEiLCJ0eXAiOiJCZWFyZXIiLCJhen'+
                'AiOiJlY3JlYWNoX2RldiIsInNlc3Npb25fc3RhdGUiOiI2Y2VhM2FmYi1iNTZlLTRlOGItYWY2Yi03YmViMDA0ODE0YzgiLCJhY3IiO'+
                'iIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbImFwcC1hZG1pbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7InNwcmluZ2Jvb3QtbWl'+
                'jcm9zZXJ2aWNlIjp7InJvbGVzIjpbImFkbWluIl19LCJlY3JlYWNoX2RldiI6eyJyb2xlcyI6WyJhZG1pbiJdfSwiYWNjb3VudCI6e'+
                'yJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJ'+
                'wcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJpZ25hdGljYV9kZXYifQ.'+
                'nZ9628_rJtChqK6X01tk_7pIez1fbAt6zdLD8iHgghnn8JFgEsWxVcZjtgMyWjc_7JsskwteiA8Z-BHBAPRBEwlDiXsyaiUJvdhGeg'+
                '-VlFYcXdgJMHmupKPgOMCKlvPcs4L4U9ybqaG5Qj5CBqlIBESBB5sgRtOQQ06aJAZ46Ii82SrbXFuKaSN-3vVsfXfdCMEYj6Nfsqg'+
                '-xO8X9K4U13rnreNgAXoCZ8lHdklLQ3oN_dNac1EBXxTCMXzv4hMcww5Pb5vnMQacKUJR10HRf_ECiva8hTzLTAx9qPDbW-YzVoFK'+
                '6zJovwEdsHUzRlG7r2mIXS2FtnlijASxk_doRw","iss":"https://api-uat.ec-reach.com.hk/api/",'+
                '"token_type":"Bearer","iat":"1627476752"}');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().containsIgnoreCase('https://api-uat.ec-reach.com.hk:9444/api/services/res1/v1/testConnection')){
            // tesconnection api test case.
            res.setBody('eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..2pLbt2DeGocYcSNBZ2a31g.'+
                'zSwORdkGmWD7VDH67zeR3hn8254QBZGBIxiBhqrN7L0Rp7S4g7nIvwS0jEYJ5gtl2uVjBfw2bM9fmyJWZuAbInHTGXyYyWedCF4VqoyrODC'+
                'pHfxb4jid5GwbvfW0kykdX-fR5zt5nDug7uEc7C3IFZUm9M-pDDbTTjvrhy_cShS_8-ckM1ARl3cK-IYICd-_Pno8_Ro3qK_B15Ttbuf0rh'+
                '3CwSO-DZyWWG7jh1rFzWjHBNFemss5HOALjpQRotFIAq_Y86skmsbAhKo-KpVtzf6GYDcWeOLiDpQeohVvJ6LrxwHM3N5FWRDUTj5VwzjbvP'+
                'HrfqJ0dMwC3EXZZW6yBrL72Rm_JIknA2IyE0D_2_DGphwEvbrSfsVzCXY1PASwjB1yH-l4WlVbV-ZoxtHLnGOWJwDbzC8xkoOQxpvk80t3tx_'+
                'ZGxN6yEJiUopeBsA43I1Hp3jJuyLxV0MO97ICCJF-1pcvd9IeGzTANGRsWIzh-nEmYKOuw6-t8cE5ZaOUEcXZ2JZ-5YDYq_1G8QVH18Jik9Wu'+
                '1dCHto9a6vevaqgsy_YpCVEsBr--S7xLT71izevEb4C_wEU0jfkpjLUxtNI96l-yZ0n4_IBlm2B-uiKqX7ACjMjiB7c1tm_bLk9X.'+
                '3ClWfxenhWfjQCyuAD1OX39M3JlrKoUEozpqaLoFbaA');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().containsIgnoreCase('https://api-uat.ec-reach.com.hk:9444/api/services/res1/v1/testConnectionContent')){
            // tesconnectionContent api test case.
            res.setBody('eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..re74rds-U3Wket8YYxzO2g.'+
                '6TXO_a3qDHtoH7WiAkmOFkJcDefIGyBn9qgsq-F54p1QWrCpRwENlvm_6-B8GbeaT5iuEI7vXvi4KgPUJ1ftEcVo2NARVgp05SM3h8jUhrHTI3ZMsruJ'+
                'vdAGDIV_YqoEOD-4YKmqGrqFS5iXaT2em9u_Z4BxglbUrqWKj8ALJvBc3gi_Z9726Y4Xai92VJO-QRujeCyxeEZ-I7uDOzzJkBh-dtjQNZ5YO9wpymDKkb'+
                '7FNoyEpdT4GNuBz94v5RGrpkqCyHA7pRbdE2Pj7gECFGQfI6s7TZRebA6USQ_TyMVBkMe03pu0icK7_lrnjbU3h5pihoYv2lF8zXdVusGv2aFmZ8VHYGaL'+
                'CsE08MFWTyMk1mEVB80y0r_KU0su1XK1x1laxQrQkbUxn3zbTQOY6vEf-958yRDt_8IQ2vCs0lTNXJ4oVW8Ko5WvB9H7XgRpSSSHxEWEc6Wxz2Uj7kTBme'+
                'DmS6owjbQYacAolA2uOAhZ2N9Rcs2yKTMZX8GT0JpQ4FelVaePD8WJHCzxsSVejFjaZR4zkZjYNyyqeU1trhqJxmz_yKK5ANq_6cN-9D3qm3CN7Eeq_'+
                'ODdDGt8so-Rz1pRtWKOHo5aqmxT5s3HGgAZ1MyeL6kY5RfRxvdHU7wYlP-h6UtAHdrz-ITvqNhjcw.rvkfjuB0zSlFlZtlV3MXdU9v_dgSCyiNaOqvzpuMlSg');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().containsIgnoreCase('https://api-uat.ec-reach.com.hk:9444/api/services/docsign/token')){
            // tesconnectionContent api test case.
            res.setBody('eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..a8H0PvylJ9BfZGqanyZ70w.'+
                'P28T6FLu54SWzoJS_t1F1ejrEi92-42PieukfDE3zLkFkgidqHDVI5vY5pifAn8VABosDXVcM4LQSBvQ8T3761Mpi1oTv9KfIyIp_vJLHvf7s4xilDS-'+
                'CyZo4CNkBYd6idRuQyiGZi_uR_YBHfnY-TUBr-IaQXxpdVPww9lZarVd4ExemHvZRtnMws7XZkUtsbgl3CguiAoPn2f78FKxqLcjS6Gmsz5p6-'+
                'LWsp9jbpWhx9a5ohufZjI5okut7Z9aWE-Mp1WLrNqbbRROcp4mdHFiVGmcKlhjbA3-apkjQnNRs2K9kS9syNerk4tn7XtZc-'+
                'SP5wGlS9wmOCh2dBbRwhtyak7DIY3YPAmDn_3Gr6en5dcTbGp3-R344Mh-7F0g1-IG-4m7lLGqlh98Byf_A0jzeeIkGN4dxle8WKELyQkDy4p-'+
                'CVVazWVLNIRB1f2Pxoo0Th0oXjNWdHVTtXQ8l-iAH1XgUtCjTvd6Y1oa17255i0JHugw44ZcCicMgMAmAV4NxBY_LdWWPQsIB5x6ocFrjAimG35'+
                'hmd4jnWH2z6vpRliJsX4Wsz21JCaYRsp19_2lDDR9uS6Cq5xPt-5VCduJz3wSQgu6gdoHyfLEoJQankfhVB5_O44YF5UobRjK0EfW7Z3g_PXXKrKhcG0dE4gcaerZbtKf4Q'+
                '-eqJuDxK4.V9u1DnfNmB6E6lTMbA-xhMMCn1tDFgvaJmE0a6stWjc');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().containsIgnoreCase('https://api-uat.ec-reach.com.hk:9444/api/services/docsign/testConnectionAttachment') ||
            req.getEndpoint().containsIgnoreCase('https://api-uat.ec-reach.com.hk:9444/api/services/docsign/submitPDF')){
                // tesconnectionContent api test case.
                res.setBodyAsBlob(Blob.valueOf('blob content signed for test class purposes.'));
                res.setStatusCode(200);
                return res;
        }
        return res;
    }
}