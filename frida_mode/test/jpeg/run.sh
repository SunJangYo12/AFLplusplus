export AFL_NO_UI=1
export AFL_DISABLE_TRIM=1
export AFL_FRIDA_PERSISTENT_CNT=1000000
export AFL_NO_AFFINITY=1
export AFL_TESTCACHE_SIZE=2
export AFL_FRIDA_PERSISTENT_HOOK=../../build/frida_hook.so
export AFL_FRIDA_PERSISTENT_ADDR=0x5555555563e2
export AFL_ENTRYPOINT=0x5555555563e2
export AFL_SKIP_CPUFREQ=1
export AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1

# Durasi fuzzing dalam detik
DURATION="${DURATION:-19800}" #5.5 jam


# Deteksi CPU yang tersedia
if command -v nproc >/dev/null 2>&1; then
    CPU_COUNT="$(nproc)"
else
    CPU_COUNT="$(getconf _NPROCESSORS_ONLN)"
fi

JOBS="$CPU_COUNT"
echo "CPU tersedia : $CPU_COUNT"
echo "AFL workers  : $JOBS"

mkdir -p build/frida-out

# Master
../../../afl-fuzz \
	-M master \
	-i build/in \
	-o build/frida-out \
	-m none \
	-t 1000+ \
	-d \
	-O \
	-c 0\
	-V $DURATION \
	-- \
		build/test 2147483647 2>&1 &


# Slaves
for ((i = 1; i < JOBS; i++)); do

	../../../afl-fuzz \
		-S "slave$i" \
		-i build/in \
		-o build/frida-out \
		-m none \
		-t 1000+ \
		-d \
		-O \
		-c 0\
		-V $DURATION \
		-- \
			build/test 2147483647 2>&1 &

done

wait

