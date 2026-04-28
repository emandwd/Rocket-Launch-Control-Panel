# Rocket Launch Control Panel

## Overview
This project implements a simulated rocket launch control system using x86 Assembly language and the Irvine32 library. The system models a real-world launch control panel where multiple subsystems must be verified before initiating a rocket launch.

The program demonstrates core computer organization concepts including control flow, memory usage, registers, modular programming, and system state management.

---

## Features

### Control Panel
Keyboard-based interface:
- **F** → Enable Fuel System  
- **E** → Enable Engine System  
- **S** → Activate Safety Lock  
- **L** → Launch Rocket  
- **A** → Abort Mission  

---

### Safety Verification
The system ensures all subsystems are active before launch:
- Fuel system must be enabled  
- Engine system must be ready  
- Safety lock must be activated
If any condition fails: Launch Blocked – System Is Not Ready


---

### Authorization System
- Requires a launch authorization code (default: `1234`)
- Incorrect code:
  - Access denied
  - Alarm triggered
- Correct code:
  - Access granted
  - Countdown starts

---

### Countdown System
- Countdown from **10 to 1**
- Displays numbers on screen
- Voice feedback using PowerShell speech synthesis

---

### Abort System
- Can abort at any time by pressing **A**
- Immediately stops the system
- Displays abort message
- Activates alarm sound

---

### Ignition and Launch
After countdown:
- Ignition message is displayed
- Launch success message is shown
- Speech feedback is triggered

---

### Telemetry System
Simulates real-time rocket data:
- **Altitude** → increases
- **Speed** → increases
- **Fuel** → decreases

Updates every second until fuel drops below 10%.

---

## Technologies Used
- x86 Assembly Language  
- Irvine32 Library  
- Windows API (WinExec, Beep)  
- PowerShell (for speech synthesis)  

---

## System Design Concepts
- Finite State Machine (FSM)
- Conditional branching (CMP, JE, JNE)
- Loops and iteration
- Modular procedures (PROC)
- Register-based computation (EAX, EDX)
- Memory-based state tracking

---

## How to Run
1. Install MASM and Irvine32 library  
2. Open the project in Visual Studio or MASM environment  
3. Assemble and run the program  

---

## Example Workflow
1. Enable Fuel, Engine, and Safety  
2. Press Launch  
3. Enter authorization code  
4. Countdown starts  
5. Rocket launches  
6. Telemetry is displayed  

---

## Future Improvements
- GUI interface instead of console  
- Real hardware integration (FPGA / sensors)  
- Multi-level authentication system  
- Wireless telemetry transmission  
- Fault detection system  

---

## Authors
- Eman Mohamed Dawood  
- Malak Mohamed Saad  

---

If any condition fails:
