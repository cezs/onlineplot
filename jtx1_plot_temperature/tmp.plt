set datafile separator ','
set autoscale xy
plot "< tail -n 30 temperature.log" u 0:1 with steps title 'AO-therm', "< tail -n 30 temperature.log" u 0:2 with steps title 'CPU-therm', "< tail -n 30 temperature.log" u 0:3 with steps title 'GPU-therm', "< tail -n 30 temperature.log" u 0:4 with steps title 'PLL-therm', "< tail -n 30 temperature.log" u 0:6 with steps title 'Tdiode_tegra', "< tail -n 30 temperature.log" u 0:7 with steps title 'Tboard_tegra', "< tail -n 30 temperature.log" u 0:8 with steps title 'thermal-fan-est.46'
pause 1
reread
