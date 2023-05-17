/*---------------------------------------------------
    Desc : Mock call out class for http callout test coverage purposes
    created by : sayantan@chikpea.com
    created date : 30-Jul-2021
-----------------------------------------------------*/
@isTest
global with sharing class PostContentToECICTest {
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
        res.setBody('eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..Ay81EZTQNN-mH9LR1Pu30g.FIYoO5-IxEyK7VV_'+
            '9uIlHEVe7Dukdbha6AGlH32ciXJMmzcYtu2Kon9C_7cQ-1_69yU402Tlf70JSb0ywl8sGp7mHCCPH4Z1tdctDcT_GypIhUpI-'+
            'CuMCD8FgkWcbDMpRxVsDN2iqaTgeYBzI0j_3U-98Rsipn2AMphmHJWMp-6lnnhRAuAke_66PGtdImt_'+
            'd3E0gqm59l6pFLNYPn1h6KQhahqngarflDJidqv70tj0ly-SzDyKqiaF9rQchNmkclBIierLzhVX3maXTRM2jYGth4IZ17XTRQ'+
            'YU6xHgfLtoQo2tzfKzUfcsDF_KwvlWnzOGxhMTn0sdPvo6dubYG_UCB3BEPBPy8eglswZjF_7cAL1-DYQUGtl1QymFshR3KXgQd6'+
            'Pt1FBwa2Q1Xsr9IJ0CURGEP3TbM79pE-A09mJY7meJVzlnTjGjxl2uQ2l7QFG9-2AJGZF2OzWZ2c1Gllnla2bz0m6mbniUJfwWwt'+
            '8UkgOGbJ15sIWYottI4qxqx7_Hwf5WPiMrEbLGd90bVPRr1HGSc5sdJcsJ4jGpwx_WapvFqQ3oJRwuWLf2zYq-W8O2vXHLOxaHt'+
            'dFFzeZv5t9acjHxMTI06iBM351GEMk.O-HwPSZL9EBJeldGEi9oQrbjnGgQVd5I9X55hyx43bk');
        res.setStatusCode(200);
        return res;
    }

}