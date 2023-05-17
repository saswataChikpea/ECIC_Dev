public with sharing class PolicyResponseFormat {
    public Integer code{ get; set; }
    public String message{ get; set; }
    public String status{ get; set; }
    public String id{ get; set; }
    public String name{ get; set; }
    public CustomerDetails customer{get;set;}
    public PlanObj plan{ get; set; }
    public class PlanObj{
        public String id{ get; set; }
        public String name{ get; set; }
        public String fullName{ get; set; }
        public String description{ get; set; }
    }
    public class CustomerDetails{
        public String id{ get; set; }
        public String policyHolderName{ get; set; }
        public String email{ get; set; }
        public String phone{ get; set; }
        public string address{get;set;}
    }
    public PolicySchedule polSch{ get; set; }
    public class PolicySchedule{
        public String id{ get; set; }
        public String name{ get; set; }
    }
}