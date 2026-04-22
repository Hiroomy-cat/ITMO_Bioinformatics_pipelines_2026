#!/usr/bin/env python3
import sys
import matplotlib.pyplot as plt

def main(input_file, output_file):
    positions = []
    depths = []
    
    with open(input_file, 'r') as f:
        for line in f:
            parts = line.strip().split('\t')
            if len(parts) >= 3:
                positions.append(int(parts[1]))
                depths.append(int(parts[2]))

    plt.figure(figsize=(10, 6))
    plt.fill_between(positions, depths, color="skyblue", alpha=0.4)
    plt.plot(positions, depths, color="Slateblue", alpha=0.6)
    plt.xlabel('Position in Genome')
    plt.ylabel('Read Depth')
    plt.title('Genome Coverage Plot')
    plt.savefig(output_file)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
