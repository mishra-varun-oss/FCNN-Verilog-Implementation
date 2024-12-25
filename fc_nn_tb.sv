`include "fc_nn_layer.sv"

module nn_testbench;

    reg clk, reset;
    reg [7:0] inputs [0:9];      // 10 inputs, 8 bits each
    reg [7:0] weights [99:0];   // 800 weights, 8 bits each
    reg [7:0] biases [0:9];      // 10 biases, 8 bits each
    wire [7:0] outputs [0:9];

    reg [7:0] i;
    
    // Instantiate the neural network module
    neural_net uut (
        .clk(clk),
        .reset(reset),
        .inputs(inputs),
        .weights(weights),
        .biases(biases),
        .outputs(outputs)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize clock and reset
        clk = 0;
        reset = 1;
        #5 reset = 0;

        // Apply test data: Initialize inputs and biases
      for (i = 0; i < 10; i = i + 1) begin
        inputs[i] = 9 - i;
        biases[i] = i;
      end


        // Initialize weights array using a loop (count up and down)
 
      for (i = 0; i < 100; i = i + 1) begin
            weights[i] = i; // Assign the value to the weights array
        end


      $display("inputs: %p", inputs);
      $display("weights: %p", weights);
      $display("biases: %p", biases);
        // Wait for a few clock cycles
        #100;

        // Display the outputs
        $display("Outputs: %p", outputs);
    end

endmodule
