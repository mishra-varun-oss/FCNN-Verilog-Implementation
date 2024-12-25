import numpy as np

def relu(x):
    """ReLU activation function."""
    return np.maximum(0, x)

def quantize_to_8bit(value):
    """Quantize the value to 8 bits, clamping between 0 and 255."""
    return np.clip(value, 0, 255)

def neural_net(inputs, weights, biases):
    """Feedforward function of a neural network with quantization and ReLU."""
    outputs = np.zeros(10, dtype=np.uint8)  # 10 outputs, 8 bits each (quantized)
    
    # Perform MAC and apply ReLU activation for each neuron
    mac_result = np.zeros(10, dtype=int)  # Array to hold MAC results for each neuron
    
    for i in range(10):  # For each neuron
        mac_result[i] = biases[i]  # Start with the bias for neuron i
        
        # Perform MAC operation
        for j in range(10):  # For each input
            mac_result[i] += inputs[j] * weights[i * 10 + j]  # Weighted sum for each neuron
        
    # Apply ReLU activation and quantize to 8 bits for each neuron
    print(f"MAC results before ReLU and quantization: {mac_result}")
    
    # Apply ReLU activation and quantize over the entire array
    mac_result = relu(mac_result)  # Apply ReLU to all elements
    mac_result = quantize_to_8bit(mac_result)  # Quantize to 8-bit values
    
    outputs = mac_result.astype(np.uint8)  # Store the final quantized outputs
    
    return outputs

# Example test
if __name__ == "__main__":
    # Example inputs, weights, and biases
    inputs = np.array([9 - i for i in range(10)], dtype=np.uint8)
    
    # Initialize weights (800 values in a flattened array)
    weights = np.array([i % 50 for i in range(100)], dtype=np.uint8)  # 100 values, 8-bit
    
    # Initialize biases (10 values, 8-bit)
    biases = np.array([i for i in range(10)], dtype=np.uint8)
    
    print(weights)
    print(inputs)
    print(biases)
    # Run the neural network
    outputs = neural_net(inputs, weights, biases)
    
    # Print the results
    print("Outputs:", outputs)