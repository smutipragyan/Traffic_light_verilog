`define TRUE 1'b1 
 `define FALSE 1'b0 
 `define FALSE 1'b0
 module testbench; 
 wire [1:0] MAIN_SIG, COUNTRY_SIG; 
 reg VEHICLE_ON_COUNTRY_ROAD; 
 reg CLOCK, CLEAR; 
 
 `define YtoRDELAY 3  
 `define RtoGDELAY 2 
 module sig_control
  (HIGHWAY, COUNTRY, X, clock, clear); 
 signal_control SC(MAIN_SIG, COUNTRY_SIG, VEHICLE_ON_COUNTRY_ROAD, CLOCK, CLEAR); 
 
 output [1:0] HIGHWAY, COUNTRY; 
 reg [1:0] HIGHWAY, COUNTRY;  
 input X; 
 input clock, clear; 
 parameter RED = 2'd0, 
  YELLOW = 2'd1, 
  GREEN = 2'd2; 
 parameter S0 = 3'd0, 
  S1 = 3'd1,  
  S2 = 3'd2,  
  S3 = 3'd3,  
  S4 = 3'd4;  
 reg [2:0] state; 
 reg [2:0] next_state; 
 always @(posedge clock) 
  if (clear) 
  state <= S0;  
  else 
  state <= next_state;  
 always @(state) 
 initial 
  $monitor($time, " Main Sig = %b Country Sig = %b Vehicle_on_country = %b", 
  MAIN_SIG, COUNTRY_SIG, VEHICLE_ON_COUNTRY_ROAD); 
 
 initial 
 begin 
  HIGHWAY = GREEN;  
  COUNTRY = RED;  
  case(state) 
  S0: ; 
  S1: HIGHWAY = YELLOW; 
  S2: HIGHWAY = RED; 
  S3: begin 
  HIGHWAY = RED; 
  COUNTRY = GREEN; 
  end 
  S4: begin 
  HIGHWAY = RED; 
  COUNTRY = YELLOW; 
  end 
  endcase 
  CLOCK = `FALSE; 
  forever #5 CLOCK = ~CLOCK; 
 end 
 
 always @(state or X) 
 initial 
 begin 
  CLEAR = `TRUE;
  repeat (5) @(negedge CLOCK); 
  CLEAR = `FALSE; 
 end  
 initial 
 begin 
  case (state) 
  S0: if(X) 
  next_state = S1; 
  else 
  next_state = S0; 
  S1: begin 
  repeat(`YtoRDELAY) @(posedge clock) ;
 next_state = S2; 
  end 
  S2: begin  
  repeat(`RtoGDELAY) @(posedge clock); 
  next_state = S3; 
  end 
  S3: if(X) 
  next_state = S3; 
  else 
  next_state = S4; 
  S4: begin  
  repeat(`YtoRDELAY) @(posedge clock) ; 
  next_state = S0; 
  end 
  default: next_state = S0; 
  endcase 
  VEHICLE_ON_COUNTRY_ROAD = `FALSE; 
  repeat(20)@(negedge CLOCK); VEHICLE_ON_COUNTRY_ROAD = `TRUE; 
  repeat(10)@(negedge CLOCK); VEHICLE_ON_COUNTRY_ROAD = `FALSE; 
  repeat(20)@(negedge CLOCK); VEHICLE_ON_COUNTRY_ROAD = `TRUE; 
  repeat(10)@(negedge CLOCK); VEHICLE_ON_COUNTRY_ROAD = `FALSE; 
  repeat(20)@(negedge CLOCK); VEHICLE_ON_COUNTRY_ROAD = `TRUE; 
  repeat(10)@(negedge CLOCK); VEHICLE_ON_COUNTRY_ROAD = `FALSE; 
  repeat(10)@(negedge CLOCK); 
 $stop; 
 end 
 endmodule
 endmodule 
