public  with sharing class NFC_Response{
	
	public String reportReceivedDate;	//2021-11-12
	public String reviewDate;	//
	public String reviewOfficer;	//
	public String acknowledgeStatus;	//Y
	public cls_Case[] nfcCase;
	
	class cls_Case {
		public String caseType;	//CRT
		public String legacyCaseId ;	//50898
		public String status;	//O
		public String nfcCaseDate;	//2021-1-1
		public String nfcCaseAmount;	//100
		public String nfcCaseCreateRemarks;	//a
		public String nfcCaseUpdateRemarks;	//
	}
	public static NFC_Response parse(String json){
		return (NFC_Response) System.JSON.deserialize(json, NFC_Response.class);
	}
}