Introduction
============

This is by no means meant to show other how to implement a riscv processor. It's
my own journey into Verilog and the RISC-V spec.

Almost all of the work is based off of the `from blinker to riscv`_.

.. from blinker to riscv: https://github.com/BrunoLevy/learn-fpga/tree/master/FemtoRV/TUTORIALS/FROM_BLINKER_TO_RISCV


Setup
=====

.. code-block:: console

   $ # install icarus
   $ sudo dnf install verilator iverilog

   $ # install verilator
   $ sudo dnf install verilator

   $ # install cocotb
   $ sudo dnf install make python3 python3-pip
   $ python -m virtualenv cocotb-venv
   $ source ./cocotb-venv/bin/activate
   $ pip install cocotb
