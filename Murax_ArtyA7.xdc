set_property IOSTANDARD LVCMOS33 [get_ports {io_gpioA_write[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_gpioA_read[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_gpioA_writeEnable[*]}]
## ============================================================
## Murax SoC - Digilent Arty A7-35T (XC7A35TICSG324-1L)
## FINAL - All 104 ports constrained, zero pin conflicts
## Ports: write[31:0] read[31:0] writeEnable[31:0] + clk/rst/uart/jtag
## ============================================================

## ------------------------------------------------------------
## Clock (100 MHz)
## ------------------------------------------------------------
set_property PACKAGE_PIN E3 [get_ports io_mainClk]
set_property IOSTANDARD LVCMOS33 [get_ports io_mainClk]
create_clock -period 10.000 -name sys_clk [get_ports io_mainClk]

## ------------------------------------------------------------
## Reset (ck_rst active-low)
## ------------------------------------------------------------
set_property PACKAGE_PIN C2 [get_ports io_asyncReset]
set_property IOSTANDARD LVCMOS33 [get_ports io_asyncReset]
set_false_path -from [get_ports io_asyncReset]

## ------------------------------------------------------------
## UART (FT2232HQ)
## D10=uart_rxd_out (FPGA TX)  A9=uart_txd_in (FPGA RX)
## ------------------------------------------------------------
set_property PACKAGE_PIN D10 [get_ports io_uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports io_uart_txd]
set_property PACKAGE_PIN A9 [get_ports io_uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports io_uart_rxd]

## ------------------------------------------------------------
## JTAG (PMOD JA lower row: JA1-JA4)
## ------------------------------------------------------------
set_property PACKAGE_PIN G13 [get_ports io_jtag_tck]
set_property PACKAGE_PIN B11 [get_ports io_jtag_tdi]
set_property PACKAGE_PIN A11 [get_ports io_jtag_tdo]
set_property PACKAGE_PIN D12 [get_ports io_jtag_tms]
set_property IOSTANDARD LVCMOS33 [get_ports io_jtag_tck]
set_property IOSTANDARD LVCMOS33 [get_ports io_jtag_tdi]
set_property IOSTANDARD LVCMOS33 [get_ports io_jtag_tdo]
set_property IOSTANDARD LVCMOS33 [get_ports io_jtag_tms]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets io_jtag_tck_IBUF]
create_clock -period 100.000 -name jtag_clk [get_ports io_jtag_tck]
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks jtag_clk]
set_false_path -from [get_ports io_jtag_tdi]
set_false_path -from [get_ports io_jtag_tms]

## ============================================================
## GPIO WRITE [31:0]
## [0:3]   LD0-LD3  plain green LEDs
## [4:7]   LD4/LD5  RGB G+B channels
## [8:15]  PMOD JB
## [16:23] PMOD JC
## [24:31] PMOD JD
## ============================================================

set_property PACKAGE_PIN H5 [get_ports {io_gpioA_write[0]}]
set_property PACKAGE_PIN J5 [get_ports {io_gpioA_write[1]}]
set_property PACKAGE_PIN T9 [get_ports {io_gpioA_write[2]}]
set_property PACKAGE_PIN T10 [get_ports {io_gpioA_write[3]}]
set_property PACKAGE_PIN E15 [get_ports {io_gpioA_write[4]}]
set_property PACKAGE_PIN E16 [get_ports {io_gpioA_write[5]}]
set_property PACKAGE_PIN D15 [get_ports {io_gpioA_write[6]}]
set_property PACKAGE_PIN C15 [get_ports {io_gpioA_write[7]}]

set_property PACKAGE_PIN G14 [get_ports {io_gpioA_write[8]}]
set_property PACKAGE_PIN D18 [get_ports {io_gpioA_write[9]}]
set_property PACKAGE_PIN E18 [get_ports {io_gpioA_write[10]}]
set_property PACKAGE_PIN G17 [get_ports {io_gpioA_write[11]}]
set_property PACKAGE_PIN C17 [get_ports {io_gpioA_write[12]}]
set_property PACKAGE_PIN D17 [get_ports {io_gpioA_write[13]}]
set_property PACKAGE_PIN E17 [get_ports {io_gpioA_write[14]}]
set_property PACKAGE_PIN F18 [get_ports {io_gpioA_write[15]}]

set_property PACKAGE_PIN U12 [get_ports {io_gpioA_write[16]}]
set_property PACKAGE_PIN V12 [get_ports {io_gpioA_write[17]}]
set_property PACKAGE_PIN V10 [get_ports {io_gpioA_write[18]}]
set_property PACKAGE_PIN V11 [get_ports {io_gpioA_write[19]}]
set_property PACKAGE_PIN U14 [get_ports {io_gpioA_write[20]}]
set_property PACKAGE_PIN V14 [get_ports {io_gpioA_write[21]}]
set_property PACKAGE_PIN T13 [get_ports {io_gpioA_write[22]}]
set_property PACKAGE_PIN U13 [get_ports {io_gpioA_write[23]}]

set_property PACKAGE_PIN D4 [get_ports {io_gpioA_write[24]}]
set_property PACKAGE_PIN D3 [get_ports {io_gpioA_write[25]}]
set_property PACKAGE_PIN F4 [get_ports {io_gpioA_write[26]}]
set_property PACKAGE_PIN F3 [get_ports {io_gpioA_write[27]}]
set_property PACKAGE_PIN E2 [get_ports {io_gpioA_write[28]}]
set_property PACKAGE_PIN D2 [get_ports {io_gpioA_write[29]}]
set_property PACKAGE_PIN H2 [get_ports {io_gpioA_write[30]}]
set_property PACKAGE_PIN G2 [get_ports {io_gpioA_write[31]}]

## ============================================================
## GPIO READ [31:0]
## [0:3]   SW0-SW3   slide switches
## [4:7]   BTN0-BTN3 push buttons
## [8:21]  ChipKit ck_io[0:13]
## [22:27] ChipKit ck_io[14:19] (analog header as digital)
## [28:31] ChipKit ck_io[26:29]
## ============================================================

set_property PACKAGE_PIN A8 [get_ports {io_gpioA_read[0]}]
set_property PACKAGE_PIN C11 [get_ports {io_gpioA_read[1]}]
set_property PACKAGE_PIN C10 [get_ports {io_gpioA_read[2]}]
set_property PACKAGE_PIN A10 [get_ports {io_gpioA_read[3]}]
set_property PACKAGE_PIN D9 [get_ports {io_gpioA_read[4]}]
set_property PACKAGE_PIN C9 [get_ports {io_gpioA_read[5]}]
set_property PACKAGE_PIN B9 [get_ports {io_gpioA_read[6]}]
set_property PACKAGE_PIN B8 [get_ports {io_gpioA_read[7]}]

set_property PACKAGE_PIN V15 [get_ports {io_gpioA_read[8]}]
set_property PACKAGE_PIN U16 [get_ports {io_gpioA_read[9]}]
set_property PACKAGE_PIN P14 [get_ports {io_gpioA_read[10]}]
set_property PACKAGE_PIN T11 [get_ports {io_gpioA_read[11]}]
set_property PACKAGE_PIN R10 [get_ports {io_gpioA_read[12]}]
set_property PACKAGE_PIN R11 [get_ports {io_gpioA_read[13]}]
set_property PACKAGE_PIN R13 [get_ports {io_gpioA_read[14]}]
set_property PACKAGE_PIN A1 [get_ports {io_gpioA_read[15]}]
set_property PACKAGE_PIN A13 [get_ports {io_gpioA_read[16]}]
set_property PACKAGE_PIN N14 [get_ports {io_gpioA_read[17]}]
set_property PACKAGE_PIN N16 [get_ports {io_gpioA_read[18]}]
set_property PACKAGE_PIN V17 [get_ports {io_gpioA_read[19]}]
set_property PACKAGE_PIN U18 [get_ports {io_gpioA_read[20]}]
set_property PACKAGE_PIN R16 [get_ports {io_gpioA_read[21]}]
set_property PACKAGE_PIN F5 [get_ports {io_gpioA_read[22]}]
set_property PACKAGE_PIN D8 [get_ports {io_gpioA_read[23]}]
set_property PACKAGE_PIN C7 [get_ports {io_gpioA_read[24]}]
set_property PACKAGE_PIN E7 [get_ports {io_gpioA_read[25]}]
set_property PACKAGE_PIN D7 [get_ports {io_gpioA_read[26]}]
set_property PACKAGE_PIN D5 [get_ports {io_gpioA_read[27]}]
set_property PACKAGE_PIN U11 [get_ports {io_gpioA_read[28]}]
set_property PACKAGE_PIN U17 [get_ports {io_gpioA_read[29]}]
set_property PACKAGE_PIN T14 [get_ports {io_gpioA_read[30]}]
set_property PACKAGE_PIN T15 [get_ports {io_gpioA_read[31]}]

## ============================================================
## GPIO WRITE-ENABLE [31:0]
## Murax tristate direction bus - output only, no physical function.
## Assigned to unused pins: LD4-R, LD5-R, JA upper row, shield IO.
## All set_false_path so timing is never checked.
## ============================================================

set_property PACKAGE_PIN F6 [get_ports {io_gpioA_writeEnable[0]}]
set_property PACKAGE_PIN A15 [get_ports {io_gpioA_writeEnable[1]}]
set_property PACKAGE_PIN A16 [get_ports {io_gpioA_writeEnable[2]}]
set_property PACKAGE_PIN F13 [get_ports {io_gpioA_writeEnable[3]}]
set_property PACKAGE_PIN C14 [get_ports {io_gpioA_writeEnable[4]}]
set_property PACKAGE_PIN D13 [get_ports {io_gpioA_writeEnable[5]}]
set_property PACKAGE_PIN A18 [get_ports {io_gpioA_writeEnable[6]}]
set_property PACKAGE_PIN A14 [get_ports {io_gpioA_writeEnable[7]}]

set_property PACKAGE_PIN T16 [get_ports {io_gpioA_writeEnable[8]}]
set_property PACKAGE_PIN R17 [get_ports {io_gpioA_writeEnable[9]}]
set_property PACKAGE_PIN T5 [get_ports {io_gpioA_writeEnable[10]}]
set_property PACKAGE_PIN R5 [get_ports {io_gpioA_writeEnable[11]}]
set_property PACKAGE_PIN V5 [get_ports {io_gpioA_writeEnable[12]}]
set_property PACKAGE_PIN V4 [get_ports {io_gpioA_writeEnable[13]}]
set_property PACKAGE_PIN R3 [get_ports {io_gpioA_writeEnable[14]}]
set_property PACKAGE_PIN T3 [get_ports {io_gpioA_writeEnable[15]}]

set_property PACKAGE_PIN R2 [get_ports {io_gpioA_writeEnable[16]}]
set_property PACKAGE_PIN T1 [get_ports {io_gpioA_writeEnable[17]}]
set_property PACKAGE_PIN T6 [get_ports {io_gpioA_writeEnable[18]}]
set_property PACKAGE_PIN U6 [get_ports {io_gpioA_writeEnable[19]}]
set_property PACKAGE_PIN V7 [get_ports {io_gpioA_writeEnable[20]}]
set_property PACKAGE_PIN U7 [get_ports {io_gpioA_writeEnable[21]}]
set_property PACKAGE_PIN A3 [get_ports {io_gpioA_writeEnable[22]}]
set_property PACKAGE_PIN V9 [get_ports {io_gpioA_writeEnable[23]}]

set_property PACKAGE_PIN R6 [get_ports {io_gpioA_writeEnable[24]}]
set_property PACKAGE_PIN U8 [get_ports {io_gpioA_writeEnable[25]}]
set_property PACKAGE_PIN N15 [get_ports {io_gpioA_writeEnable[26]}]
set_property PACKAGE_PIN P15 [get_ports {io_gpioA_writeEnable[27]}]
set_property PACKAGE_PIN K13 [get_ports {io_gpioA_writeEnable[28]}]
set_property PACKAGE_PIN L13 [get_ports {io_gpioA_writeEnable[29]}]
set_property PACKAGE_PIN M13 [get_ports {io_gpioA_writeEnable[30]}]
set_property PACKAGE_PIN A4 [get_ports {io_gpioA_writeEnable[31]}]

set_false_path -to [get_ports {io_gpioA_writeEnable[*]}]

## ------------------------------------------------------------
## Bitstream config
## ------------------------------------------------------------
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

create_clock -period 100.000 -name jtag_clk [get_ports io_jtag_tck]

