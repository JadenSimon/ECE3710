create_clock -name "Clock" -period 20.000ns [get_ports {Clock}] 
derive_pll_clocks 