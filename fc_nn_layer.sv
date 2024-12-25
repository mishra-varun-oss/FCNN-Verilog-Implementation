// Fully connected 1-layer neural network with 8-bit quantization
module neural_net (
    input clk,
    input reset,
    input [7:0] inputs [0:9],      // 10 inputs, 8 bits each
    input [7:0] weights [99:0],   // 100 weights, 8 bits each
    input [7:0] biases [0:9],      // 10 biases, 8 bits each
    output reg [7:0] outputs [0:9] // 10 outputs, 8 bits each
);

    reg signed [15:0] mac_result [0:9]; // MAC result for each neuron
    integer i, j, idx; // Loop variables

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            for (i = 0; i < 10; i = i + 1) begin
                outputs[i] <= 8'b0;
                mac_result[i] <= 16'b0;
            end
        end else begin
            // Compute MAC for each neuron
            for (i = 0; i < 10; i = i + 1) begin
                mac_result[i] = biases[i]; // Start with the bias
                for (j = 0; j < 10; j = j + 1) begin
                    idx = i * 10 + j;
                    mac_result[i] = mac_result[i] + 
                                    (inputs[j] * weights[idx]);
                end

                // Apply ReLU activation and quantize to 8 bits
                if (mac_result[i] < 0) begin
                    outputs[i] <= 8'b0;
                end else if (mac_result[i] > 255) begin
                    outputs[i] <= 8'd255; // Saturate to 8 bits
                end else begin
                    outputs[i] <= mac_result[i]; // Truncate to 8 bits
                end
            end
        end
    end

endmodule