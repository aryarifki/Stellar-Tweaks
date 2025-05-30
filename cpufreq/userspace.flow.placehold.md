# How It Works

## Initialization
1. The governor registers itself with the CPUfreq subsystem during kernel init
2. When activated for a CPU, it:
   - Allocates memory for storing the target frequency
   - Marks the CPU as managed
   - Sets initial frequency to current policy frequency

## Frequency Setting
1. Userspace writes desired frequency to `scaling_setspeed`
2. `cpufreq_set()` validates the request and:
   - Checks if CPU is managed by this governor
   - Stores the requested frequency
   - Calls driver to actually set the frequency

## Event Handling
The governor responds to several events:
- `CPUFREQ_GOV_START`: Starts managing a CPU
- `CPUFREQ_GOV_STOP`: Stops managing a CPU
- `CPUFREQ_GOV_LIMITS`: Adjusts frequency when policy limits change
- `CPUFREQ_GOV_POLICY_EXIT`: Cleans up when policy ends

## Thread Safety
- Uses `userspace_mutex` to protect:
  - Access to per-CPU managed flags
  - Frequency setting operations
  - Governor data structure modifications

## Frequency Adjustment Logic
When policy limits change:
1. If stored frequency is above new max, sets to max
2. If stored frequency is below new min, sets to min
3. Otherwise, keeps current stored frequency

This governor provides a simple bridge between userspace applications and the CPU frequency drivers, allowing manual control while respecting system constraints.
