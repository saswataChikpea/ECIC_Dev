public with sharing class NFC_ResponseFromLegacy {
  
	public String rtn_code;	//1
	public rtn_msgs[] rtn_msgs;
	public meta_data meta_data;
	public nfc nfc;
	public cases cases;
	
	public class meta_data {
		public nfc[] nfc;
	}
	public class rtn_msgs {
		public String rtn_msgs;
		public String msg_code;
		public String msg_data;
		public String msg_desc;
	}
	public class nfc {
		public String rpt_recv_date;
		public String rev_date;
		public String rev_ofr;
		public String ack_sts;
		public cases[] cases;
	}
	public class cases {
		public String case_type;
		public String case_id;
		public String case_sts;
		public String case_date;
		public String case_amt;
		public String case_create_rmk;
		public String case_update_rmk;
	}
	public static NFC_ResponseFromLegacy parse(String json){
		return (NFC_ResponseFromLegacy) System.JSON.deserialize(json, NFC_ResponseFromLegacy.class);
	}

	/*static testMethod void testParse() {
		String json=		'{"rtn_code":"1","rtn_msgs":null,"meta_data":{"nfc":[{"rpt_recv_date":null,"rev_date":null,"rev_ofr":null,"ack_sts":null,"cases":null}]}}';
		fromJSON obj = parse(json);
		System.assert(obj != null);
	}*/

}