
// mux8.v - logic for 8-to-1 multiplexer

module mux8 #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] d0, d1, d2, d3, d4, d5, d6, d7,
    input  [2:0] sel,
    output [WIDTH-1:0] y
);

assign y = sel[2] ? 
              (sel[1] ? (sel[0] ? d7 : d6)
                      : (sel[0] ? d5 : d4))
          :
              (sel[1] ? (sel[0] ? d3 : d2)
                      : (sel[0] ? d1 : d0));

endmodule

