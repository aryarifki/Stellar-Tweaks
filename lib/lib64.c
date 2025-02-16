#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>

// Fungsi untuk membaca nama paket dari file game.txt
char* read_package_name() {
    FILE* file = fopen("/data/adb/modules/hiyorix/lib/game.txt", "r");
    if (file == NULL) {
        perror("Error opening file");
        return NULL;
    }

    char buffer[128];
    char* package_name = NULL;
    if (fgets(buffer, sizeof(buffer), file) != NULL) {
        // Hapus karakter newline jika ada
        char* newline = strchr(buffer, '\n');
        if (newline != NULL) {
            *newline = '\0';
        }
        package_name = strdup(buffer);
    }

    fclose(file);
    return package_name;
}

// Fungsi untuk mendapatkan PID berdasarkan nama paket
int get_pid_by_package_name(const char* package_name) {
    char command[256];
    snprintf(command, sizeof(command), "pidof -s %s", package_name);
    char buffer[128];
    FILE* pipe = popen(command, "r");
    if (pipe == NULL) {
        perror("Error executing pidof command");
        return 0;
    }
    if (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        pclose(pipe);
        return atoi(buffer);
    }
    pclose(pipe);
    return 0;
}

// Fungsi untuk menampilkan notifikasi
void show_notification(const char* message) {
    char command[256];
    snprintf(command, sizeof(command), "am start -a android.intent.action.MAIN -e toasttext \"%s\" -n bellavita.toast/.MainActivity", message);
    system(command);
}

int main() {
    char* package_name = read_package_name();
    if (package_name == NULL) {
        fprintf(stderr, "Error reading package name from file\n");
        return 1;
    }

    int old_pid = 0;
    bool app_running = false;

    while (true) {
        int pid = get_pid_by_package_name(package_name);

        if (pid > 0) {
            // Kalo Hok running, renice proses
            if (!app_running || pid != old_pid) {
                char renice_command[128];
                sprintf(renice_command, "renice -n -20 -p %d", pid);
                system(renice_command);
                sprintf(renice_command, "ionice -c 1 -n 0 -p %d", pid);
                system(renice_command);
                sprintf(renice_command, "chrt -f -p 99 %d", pid);
                system(renice_command);

                char notification_message[128];
                sprintf(notification_message, "~ %s sedang berjalan, Mengoptimalkan prioritas renice.", package_name);
                show_notification(notification_message);

                old_pid = pid;
                app_running = true;
            }
        } else {
            // Kalo Hok berhenti, stop renice lalu tunggu
            if (app_running) {
                char notification_message[128];
                sprintf(notification_message, "~ %s berhenti berjalan.", package_name);
                show_notification(notification_message);

                char renice_reset_command[128];
                sprintf(renice_reset_command, "renice -n 0 -p %d", old_pid);
                system(renice_reset_command);
                sprintf(renice_reset_command, "ionice -c 2 -n 5 -p %d", old_pid);
                system(renice_reset_command);
                sprintf(renice_reset_command, "chrt -r -p 0 %d", old_pid);
                system(renice_reset_command);
                // Reset old_pid sama app_running
                old_pid = 0;
                app_running = false;
            }
        }
        sleep(1);
    }

    free(package_name);
    return 0;
}
