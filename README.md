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
**GUI:** Sources panel → right-click **Constraints** → Add Sources → Add or create design sources → select the (*.v)
**GUI:** Sources panel → right-click **Constraints** → Add Sources → Add or create constraints → select the XDC

PS: Load the provided `murax_arty_a7_final.xdc` to your project.
then:
**GUI:** Flow Navigator → **Run Synthesis**
**GUI:** Flow Navigator → **Run Implementation**
**GUI:** Flow Navigator → **Generate Bitstream**

Confirm all flows completed with no error, and the bitstream was created successfully:
```tcl
get_property DIRECTORY [get_runs impl_1]
get_property STATUS [get_runs impl_1]
```
The generated file, by default, is located in:
/home/<user>/vexriscv/vexriscv.runs/impl_1/Murax.bit


## Step 9 — Program the FPGA

1. Connect the Arty A7 via USB. Green power LED should be on.

2. Open Hardware Manager:

**GUI:** Flow Navigator → **Open Hardware Manager** → **Open Target** → **Auto Connect**

**Tcl:**
```tcl
open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
```

3. Set the correct bitstream file and program:

**Tcl:**
```tcl
set_property PROGRAM.FILE \
  {/home/<user>/vexriscv/vexriscv.runs/impl_1/Murax.bit} \
  [get_hw_devices xc7a35t_0]
program_hw_devices [get_hw_devices xc7a35t_0]
```

**GUI:** Right-click `xc7a35t_0` → **Program Device** → browse to `Murax.bit` → **Program**

4. Success indicator: DONE LED (green LED near USB) lights up on the Arty A7 board.

---

## Common Errors

### `End of startup status: LOW`
FPGA did not configure successfully. Most common causes:
- Wrong file selected — make sure it is `Murax.bit` not the Vivado installer `.bin`
- Bitstream not generated — run Step 8 first
- Pin constraint hitting a configuration pin — re-check XDC

Verify your bitstream path:
```tcl
get_property PROGRAM.FILE [get_hw_devices xc7a35t_0]
```

### `'set_property' expects at least one object`
A port name in the XDC does not exist in the netlist. Run:
```tcl
get_ports *
```
and compare against the XDC port names.

### `Cannot set LOC — PACKAGE_PIN occupied`
Two ports assigned to the same physical pin. Each pin can only have one port. Check for duplicates in the XDC.

### `N13 is not a valid site or package pin name`
The pin does not exist on XC7A35T (it may be valid on XC7A100T). Confirm valid pins:
```tcl
get_package_pins -filter {IS_BONDED == 1}
```

### Synthesis completes but implementation fails timing
Add a timing constraint or reduce clock frequency. For Murax small config, 100 MHz is achievable. Edit the XDC clock period:
```tcl
create_clock -period 10.000 ...   # 100 MHz
create_clock -period 12.500 ...   # 80 MHz (safer)
```

---

## Quick Reference — Tcl Full Flow

```tcl
# Full flow from open project to programmed FPGA
open_project /home/<user>/vexriscv/vexriscv.xpr
launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set_property PROGRAM.FILE \
  {/home/<user>/vexriscv/vexriscv.runs/impl_1/Murax.bit} \
  [get_hw_devices xc7a35t_0]
program_hw_devices [get_hw_devices xc7a35t_0]
```

---
3. Copy the generated files to your project:
   ```bash
   mkdir -p ~/vexriscv/vexriscv.srcs/sources_1/imports
   cp Murax.v ~/vexriscv/vexriscv.srcs/sources_1/imports/
   ```

---
## Board LED Reference (Arty A7-35T)

| LED | Color | Pin | Meaning in Murax |
|---|---|---|---|
| LD0 | Green | H5 | `io_gpioA_write[0]` |
| LD1 | Green | J5 | `io_gpioA_write[1]` |
| LD2 | Green | T9 | `io_gpioA_write[2]` |
| LD3 | Green | T10 | `io_gpioA_write[3]` |
| LD4-G | Green | E15 | `io_gpioA_write[4]` |
| LD4-B | Blue | E16 | `io_gpioA_write[5]` |
| LD5-G | Green | D15 | `io_gpioA_write[6]` |
| LD5-B | Blue | C15 | `io_gpioA_write[7]` |
| DONE | Green | — | Lights when FPGA configured successfully |
