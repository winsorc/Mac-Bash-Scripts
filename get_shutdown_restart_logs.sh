#!/bin/bash

# Define the output file for logs
LOG_FILE="shutdown_restart_logs.txt"
> "$LOG_FILE"  # Clear the log file before starting

echo "=== macOS Shutdown/Restart/Logout Diagnostics ===" > "$LOG_FILE"
echo "Script run at: $(date)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 1. Get system logs around shutdown, restart, or logout
echo "=== System Log: Shutdown/Restart Events ===" >> "$LOG_FILE"
grep -iE "shutdown|restart|power|logout|sleep" /var/log/system.log* >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 2. Check for Kernel Panic logs (if any)
echo "=== Kernel Panic Logs (if any) ===" >> "$LOG_FILE"
grep -i "panic" /Library/Logs/DiagnosticReports/* >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 3. Look for any crash reports
echo "=== Crash Reports (if any) ===" >> "$LOG_FILE"
grep -i "crash" /Library/Logs/DiagnosticReports/* >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 4. Power-related logs from powerd
echo "=== Powerd Logs (power management) ===" >> "$LOG_FILE"
grep -i "powerd" /var/log/system.log* >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 5. Check for software update logs (for possible update-related restart)
echo "=== Software Update Logs ===" >> "$LOG_FILE"
grep -i "softwareupdate" /var/log/install.log >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 6. Check for shutdown/restart events in the Console logs (specific to logouts)
echo "=== Console Logs for Logout or Restart Events ===" >> "$LOG_FILE"
grep -iE "logout|restart|shutdown" /private/var/log/asl/*.asl >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 7. Check for system sleep events
echo "=== Sleep/Wake Events ===" >> "$LOG_FILE"
grep -iE "sleep|wake" /var/log/system.log* >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 8. Check for any scheduled tasks that might have caused the restart
echo "=== Cron Jobs or LaunchDaemons/Agents ===" >> "$LOG_FILE"
# Get cron jobs (if any)
crontab -l >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"
# Check for potentially misbehaving launch agents or daemons
find /Library/LaunchDaemons /Library/LaunchAgents /System/Library/LaunchDaemons /System/Library/LaunchAgents ~/Library/LaunchAgents -type f -name "*.plist" -exec cat {} \; >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 9. Print location of the log file
echo "Log file created at: $PWD/$LOG_FILE"

