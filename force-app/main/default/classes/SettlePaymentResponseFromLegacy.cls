public with sharing class SettlePaymentResponseFromLegacy {
    public class rtn_msgs {
		public Integer msg_id;
		public String msg_code;
		public String msg_data;
		public String msg_desc;
	}

	public String rtn_code;
	public List<rtn_msgs> rtn_msgs;
	public Object meta_data;

	
	public static SettlePaymentResponseFromLegacy parse(String json) {
		return (SettlePaymentResponseFromLegacy) System.JSON.deserialize(json, SettlePaymentResponseFromLegacy.class);
	}
}