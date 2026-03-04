.data
values: .word 5, 10, 15, 20, 25

.text
.globl main
main:
    # Initialize
    la x10, values
    addi x11, x0, 0      # sum = 0
    addi x12, x0, 5      # count = 5
    addi x13, x0, 0      # index = 0

loop_start:
    # DATA HAZARD: RAW dependency chain
    slli x14, x13, 2     # x14 = index * 4 (byte offset)
    add x15, x10, x14    # x15 = base + offset
    
    # DATA HAZARD: Load-use hazard
    lw x16, 0(x15)       # Load value from array
    add x11, x11, x16    # Add to sum (immediate use after load)
    
    # DATA HAZARD: Write-after-read in sequence
    addi x13, x13, 1     # Increment index
    mv x17, x13          # Copy for comparison
    
    # CONTROL HAZARD: Branch
    blt x17, x12, loop_start  # Continue if index < count
    
    # STRUCTURAL HAZARD scenario
    sw x11, 20(x10)      # Store result
    lw x18, 20(x10)      # Immediate load from same location

exit:
    addi a0, x11, 0      # Move result to a0
