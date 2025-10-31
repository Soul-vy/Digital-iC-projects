# ALSU (Arithmetic, Logic, Shift Unit) Design

The ALSU is a versatile digital hardware module widely used in processors, microcontrollers, and custom datapaths. It performs arithmetic, logic, and shift operations efficiently on binary data and is a core building block in digital systems.

---

## 📌 Usage and Features

| Category          | Details                                   |
|-------------------|-------------------------------------------|
| **Arithmetic**    | Add, Subtract, Increment, Decrement       |
| **Logic**         | AND, OR, XOR, NOT, NAND, NOR              |
| **Shift**         | Logical Shift Left/Right, Arithmetic Shift Left/Right |
| **Rotate**        | Rotate Left/Right, Rotate with Carry      |
| **Data Manipulation** | Bit masking, Parity check, Multiplication/Division via shifts |

**Benefits:**  
- Enables efficient bit-level computation  
- Essential for CPU, DSP, and custom digital systems  
- Flexible operation selection via control signals  

---

## 🔍 Design Overview

| Output           | Description                |
|------------------|----------------------------|
| Result (6 bits)  | Operation result           |
| LEDs (16 bits)   | Status and activity display|

**Internal Modules:**  
- Adder/Subtractor  
- Logic Block  
- Shifter/Rotator  
- Control Unit  

---

## ⚙️ Operation Modes
The ALSU supports multiple operation modes controlled via input signals, combining arithmetic, logic, and shift functionalities seamlessly.

---

## 🧩 RTL Implementation
The ALSU design is implemented at the RTL level, promoting modularity and ease of integration into larger digital systems.

---

## 🧪 Testbench and Verification
Comprehensive simulation and testbench automation have been performed to verify the functional correctness and robustness of the ALSU design.

---

## 📊 Simulation Results
Simulation confirms correct operation for all supported functionalities, ensuring reliable performance in real hardware.

---

## ⚠️ Constraints
Considerations have been made for timing, resource utilization, and integration complexities in the design constraints.

---

## 📄 Reports
Detailed design reports and documentation are available to support understanding and further development.

---

## 🚀 Future Enhancements
Modular design allows extension for advanced arithmetic and logic operations, as well as integration with additional peripheral modules.

---

## ✅ Summary
The ALSU offers a flexible, efficient, and verified arithmetic, logic, and shift unit implementation. Its modular structure and thorough verification make it suitable for various digital system applications.

---

## 🔗 LinkedIn Post & PDF Documentation

[View ALU Project on LinkedIn](https://www.linkedin.com/feed/update/urn:li:activity:7364965304675807232/)

Click the image above to view the full project post and access the PDF documentation on LinkedIn.



