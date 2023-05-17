/*---------------------------------------------------
    Desc : Mock call out class for http callout test coverage purposes
    created by : sayantan@chikpea.com
    created date : 30-Jul-2021
-----------------------------------------------------*/
@isTest
global with sharing class TestConnectionToECICTest {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        // System.assertEquals('https://api-uat.ec-reach.com.hk:9444', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //String bodystr = ECIC_MockCalloutTest.getresponsebody();
        res.setBody('eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..'+
            'j7oZJipKSy-_1W2qfi_iMQ.81z1EqxjsVXhHZyXeeO_z8xm7RQMpJyLsNco2BLtvI-NwSfK2NbWWPjEndgsUZqby2GPtIw7B8YR'+
            '-Qm3VeOn0HXHqh9WxZ5STPt1PPLGF4GLONma1dxol8DcQEvvxpzjU_h2HoeC4_EBR2UWOfDBPfEm2MGBu1Uuc_'+
            'njkBWb99P4oilHRvEleLFa5YHB4S1OY7tOyq5t4Vfzg9xJ48y_MWKP2vO7yn7YrIFUldhfORblxt27XT8CREotKgDb-'+
            'p_MwQjZBIpOixty8yoW76GPdh_pfdqueH9N12lqYUbZxRpTmjo0tIYu99PAcCy57yrczEughccNsoJJcIv2j43IwTbanPT'+
            'XcSzNwa6vUkAlDLSEdvNpfk1wlO25goeveW3itKUsA2OF4ta9LxaLRAuWV5HtU-PCFedrGu-qBs5AYlBCsktMDF0LM0sDk3'+
            '8NyebJMWHOog-cYAYZH0AdZK7b9q-_8TYGgIDO_-ZU6y1-6AKhhKjdJ_qqku6nyJBJWk-koVIzURCscnbkEzxe42Bc9HGhKzhL'+
            'iV4WMX82xFdOAX9VcrW9p1dXmCZMFSvk-IChwgjs8DxZ5pO0FsNUvXLiXN3hnmy4u9ldVfdl_So8PZO7bO62RId6lbqrFhAu5Xaa.'+
            'uhRsq7rajIXFzoaGksPelOK785apgtjwBs63Nug9bbk');
        res.setStatusCode(200);
        return res;
    }
}