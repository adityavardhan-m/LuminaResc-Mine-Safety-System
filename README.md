# LuminaResc – Mine Safety System

## Problem
Miners face delayed evacuation during emergencies like gas leaks and seismic activity due to poor visibility and lack of clear guidance paths.

## Solution
LuminaResc uses a smart LED guidance system that dynamically adjusts brightness based on the miner’s distance, creating a clear and energy-efficient evacuation path.

## Features
- Distance-based LED brightness control
- Gas and seismic hazard detection (simulated)
- Energy-efficient adaptive lighting system

## Methodology
- Miner movement is simulated in MATLAB along a predefined path
- Distance between miner and LEDs is continuously calculated
- LED brightness is adjusted inversely with distance:
  - Close (<20m): High brightness  
  - Medium (20–40m): Moderate brightness  
  - Far (>40m): Low brightness  
- Hazard conditions (gas/seismic) trigger the guided path lighting system

## Results
- Reduced evacuation decision time in simulations through clear path indication  
- Improved visibility by dynamically increasing LED intensity near the miner  
- Lower energy consumption compared to static full-brightness lighting  

## 📊 Simulation Outputs

### 🔹 Distance vs Brightness Control
Demonstrates how LED brightness dynamically adjusts based on the miner’s distance from the light source, ensuring optimal visibility.

![Avg PWM vs Distance](./avg_pwm_vs_distance.png)

---

### 🔹 Battery Performance
Shows battery discharge characteristics under different operating conditions, highlighting efficiency improvements.

![Battery Life](./battery_life.png)

---

### 🔹 Energy Consumption Analysis
Compares energy usage between adaptive lighting and traditional static lighting systems.

![Energy Consumption](./energy_consumption.png)

---

### 🔹 Cumulative Energy Usage
Illustrates total energy consumption over time, emphasizing long-term efficiency benefits.

![Cumulative Energy](./cumulative_energy.png)

---

### 🔹 Energy Savings Results
Quantifies the total energy saved using the proposed adaptive system.

![Energy Saving Results](./energy_saving_results.png)

---

### 🔹 Loop Frequency Accuracy
Validates system responsiveness and timing accuracy for real-time operation.

![Loop Frequency Accuracy](./loop_frequency_accuracy.png)

---

### 🔹 Illumination at Miner Position
Shows how light intensity varies at the miner’s location, ensuring consistent visibility.

![Lux at Miner](./lux_at_miner.png)

---

### 🔹 System Visualization (GUI Output)
Graphical simulation of miner movement and adaptive LED guidance system in action.

![GUI Output](./gui_output.png)>

## Demo
Watch the demo video:  
https://drive.google.com/file/d/1VvvaMlyFApfpumbpQMZ2Z2RuzVh48vud/view?usp=drivesdk

## Project Structure
- `/matlab` – src.m
- `/images` – Graphs and diagrams  
- `/docs` – Project documentation  

## Future Work
- Real-time miner tracking using IoT  
- Integration with live sensor data  
- Mobile alert system for emergency detection
