#!/usr/bin/awk -f
#
# Aggregate output of the following form:
#
# Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
# sda               0.00         0.00         0.00          0          0
# sdb               0.00         0.00         0.00          0          0
# sdc               0.00         0.00         0.00          0          0
# sdd               0.00         0.00         0.00          0          0
# sde               0.00         0.00         0.00          0          0
# sdf               0.00         0.00         0.00          0          0
# sdg               0.00         0.00         0.00          0          0
# sdi               0.00         0.00         0.00          0          0
# sdh               0.00         0.00         0.00          0          0
# sdj               0.00         0.00         0.00          0          0
# sdk               0.00         0.00         0.00          0          0
# sdl               0.00         0.00         0.00          0          0
# sdm               0.00         0.00         0.00          0          0
# sdn               0.00         0.00         0.00          0          0

# Preconfigure with our OSD device names
BEGIN { osd["sdb"] = 0; count["sdb"] = 0; last["sdb"] = 0;
        osd["sdc"] = 0; count["sdc"] = 0; last["sdc"] = 0;
        osd["sdd"] = 0; count["sdd"] = 0; last["sdd"] = 0;
        osd["sde"] = 0; count["sde"] = 0; last["sde"] = 0;
        osd["sdf"] = 0; count["sdf"] = 0; last["sdf"] = 0;
        osd["sdg"] = 0; count["sdg"] = 0; last["sdg"] = 0;
        osd["sdh"] = 0; count["sdh"] = 0; last["sdh"] = 0;
        osd["sdj"] = 0; count["sdj"] = 0; last["sdj"] = 0;
        osd["sdk"] = 0; count["sdk"] = 0; last["sdk"] = 0;
        osd["sdl"] = 0; count["sdl"] = 0; last["sdl"] = 0;
        osd["sdm"] = 0; count["sdm"] = 0; last["sdm"] = 0;
        osd["sdn"] = 0; count["sdn"] = 0; last["sdn"] = 0; }

# Ignore the first data from iostat, we need data collected per second
$1 in osd && $3 > 0.0 { if (count[$1]!=0) { osd[$1] += $3; } last[$1] = $3; count[$1]++ }

END {
        for (dev in osd)
        {
            bw=0;
            if (count[dev] > 1)
            {
                bw=(osd[dev]-last[dev])/1000.0/(count[dev]-1);
            }
            print dev, bw
        }
    }
