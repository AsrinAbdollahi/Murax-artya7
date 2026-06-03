# Murax SoC on Arty A7-35T

## Requirements

- Digilent Arty A7-35T (XC7A35TICSG324-1L)
- Ubuntu 22.04 / 24.04 (64-bit)
- ~100 GB free disk space (Vivado full install)
- Java 11+ (for SpinalHDL)
- sbt (Scala build tool)

## 1: Install Vivado 2024.2

Download the Linux self-extracting installer from AMD/Xilinx:
  https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools.html
   
After installation, open the Terminal and source the settings:
   ```bash
   source /home/<user>/vivado/Vivado/2024.2/settings64.sh
   vivado
   ```
   You can add this line to `~/.bashrc` to make it permanent.

## 2: Install SpinalHDL / sbt
To run a bitstream into an FPGA, Vivado needs a Verilog (*.v) and a Constraint (*.xdc) file.
For (*.v), you need to install Ubuntu to install sbt, following https://github.com/SpinalHDL/VexRiscv#dependencies

```bash
# JAVA JDK 8
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java
sudo update-alternatives --config javac
```
```bash
# Install SBT - https://www.scala-sbt.org/
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt-get update
sudo apt-get install sbt
```

## 3: Generate Murax Verilog from SpinalHDL
SpinalHdl provides different versions of Vexricv in src/main/scala/vexriscv/demo
As a sample, Murax-vexriscv https://github.com/SpinalHDL/VexRiscv#murax-soc

   ```bash
   #Clone VexRiscv:
   git clone https://github.com/SpinalHDL/VexRiscv.git
   cd VexRiscv
   ```
   ```bash
   #Generate the Murax SoC Verilog:
   sbt "runMain vexriscv.demo.Murax"
   ```
   This produces `Murax.v` and `Murax.bin` in the current directory.

## 4: Create Vivado Project
Launch Vivado:
   ```bash
   source /home/<user>/vivado/Vivado/2024.2/settings64.sh
   vivado
   ```
and using the GUI: **File → Project → New** and follow the wizard, selecting XC7A35TICSG324-1L.

Add source files:

- **GUI:** Sources panel → right-click **Constraints** → Add Sources → Add or create design sources → select the (*.v)
- **GUI:** Sources panel → right-click **Constraints** → Add Sources → Add or create constraints → select the XDC

PS: Load the provided `Murax_ArtyA7.xdc` to your project.
then:
- **GUI:** Flow Navigator → **Run Synthesis**
- **GUI:** Flow Navigator → **Run Implementation**
- **GUI:** Flow Navigator → **Generate Bitstream**

Confirm all flows completed with no error, and the bitstream was created successfully:
```tcl
get_property DIRECTORY [get_runs impl_1]
get_property STATUS [get_runs impl_1]
```
The generated file, by default, is located in:
/home/<user>/vexriscv/vexriscv.runs/impl_1/Murax.bit

To find your bitstream path:
```tcl
get_property PROGRAM.FILE [get_hw_devices xc7a35t_0]
```

## 5: Program the FPGA

1. Connect the Arty A7 via USB. The green power LED should be on.

2. Open Hardware Manager:

- **GUI:** Flow Navigator → **Open Hardware Manager** → **Open Target** → **Auto Connect**

3. Set the generated bitstream file and program.

- **GUI:** Right-click `xc7a35t_0` → **Program Device** → browse to `Murax.bit` → **Program**

## Common Errors

`End of startup status: LOW`
FPGA did not configure successfully. Most common causes:
- Wrong file selected, make sure it is `Murax.bit` not the Vivado installer `.bin`
- Bitstream not generated — run Step 8 first
- Pin constraint hitting a configuration pin — re-check XDC

'set_property' expects at least one object`
A port name in the XDC does not exist in the netlist. Run:
```tcl
get_ports *
```
and compare against the XDC port names.
