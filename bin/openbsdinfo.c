/*
*=======================================================================
*      Author: efek0349, (https://github.com/efek0349)
*      E-mail: kndmrefe[at]gmail[dot]com
* Description: OpenBSD system information
*     Created: 2015-04-04  T 12:04
*    Revision: 2024-08-03  T 22:28
*    FileName: openbsdinfo.c
*     Compile: $ cc openbsdinfo.c -o openbsdinfo -Wall
*=======================================================================
*

OpenBSD system information
Copyright © 2024 Me
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
must display the following acknowledgement:
This product includes software developed by the organization.
4. Neither the name of the organization nor the
names of its contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Me ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Me BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pwd.h>
#include <sys/utsname.h>
#include <sys/time.h>
#include <sys/sysctl.h>
#include <sys/statvfs.h>
#include <sys/types.h>
#include <sys/mount.h>
#include <dirent.h>

#define RST "\x1b[0m"
#define YLW "\x1b[1;33m"
#define RED "\x1b[0;31m"
#define GRY "\x1b[37m"

static void disk(void) {
    struct statfs *mntbuf;
    int mntsize;
    unsigned long total = 0;
    unsigned long free = 0;
    unsigned long used = 0;

    mntsize = getmntinfo(&mntbuf, MNT_NOWAIT);
    if (mntsize == 0) {
        perror("getmntinfo");
        exit(1);
    }

    for (int i = 0; i < mntsize; i++) {
        struct statvfs info;
        if (!statvfs(mntbuf[i].f_mntonname, &info)) {
            total += info.f_blocks * info.f_frsize;
            free += info.f_bfree * info.f_frsize;
        }
    }

    used = total - free;
    float used_perc = (float)used / total * 100.0;
    float avail_perc = (float)free / total * 100.0;

    printf(GRY"%37s%s%13s%.f%% used %.f%% free of %.fGB\n", "║", RED" Disk ", GRY"║ ",
            used_perc, avail_perc, (float)total / 1e+09);
}

static void count_packages(void) {
    DIR *dir;
    struct dirent *entry;
    int count = 0;

    dir = opendir("/var/db/pkg");
    if (dir == NULL) {
        perror("opendir");
        exit(1);
    }

    while ((entry = readdir(dir)) != NULL) {
        // Ignore "." and ".." entries
        if (entry->d_name[0] != '.') {
            count++;
        }
    }

    closedir(dir);
	printf(GRY"%37s%s%10s%d\n", "║", RED" Packages", GRY"║ ", count);
}

static void uptime(time_t *nowp) {
    struct timeval boottime;
    time_t uptime;
    int days, hrs, mins;
    int mib[2];
    size_t size;
    char buf[256];

    if (strftime(buf, sizeof(buf), NULL, localtime(nowp))) {
        mib[0] = CTL_KERN;
        mib[1] = KERN_BOOTTIME;
        size = sizeof(boottime);

        if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec) {
            uptime = *nowp - boottime.tv_sec;

            if (uptime > 60)
                uptime += 30;
            days = (int)uptime / 86400;
            uptime %= 86400;
            hrs = (int)uptime / 3600;
            uptime %= 3600;
            mins = (int)uptime / 60;
            printf(GRY"%37s%s%12s\b", "║", RED" Uptime", GRY"║ ");

            if (days > 0)
                printf(" %d day%s", days, days > 1 ? "s " : " ");

            if (hrs > 0 || mins > 0)
                printf(GRY" %02d:%02d"RST, hrs, mins);
            else
                printf(GRY" 0:00"RST);

            putchar('\n');
        }
    }
}
int main() {

    struct passwd *p;
    uid_t uid = 1000; /* $ id -u=1000 user id*/

    if ((p = getpwuid(uid)) == NULL)
        perror("getpwuid() error");

    time_t now;
    time(&now);

    char computer[256];
    struct utsname uts;
    time_t timeval;

    (void)time(&timeval);

    if (gethostname(computer, 255) != 0 || uname(&uts) < 0) {
        fprintf(stderr, "Could not get host information, so fuck off\n");
        exit(1);
    }

    printf(GRY"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀\n"RST);
    printf(YLW"  ▄████▄  ▀██████████████████████████████████▄   ▄███████ ████████▄  \n"RST);
    printf(YLW" ██    ██                            ██    ▀███ ███▀      ██    ▀███ \n"RST);
    printf(YLW" ██    ██                            ██    ▄██▀ ███▄      ██      ███\n"RST);
    printf(YLW" ██    ██ ██████▄   ▄████▄  ▄█████▄  ████████   ▀██████▄  ██      ███\n"RST);
    printf(YLW" ██    ██ ██    ██ ██▀  ▀██ ██   ▀██ ██    ▀██▄       ▀██ ██      ███\n"RST);
    printf(YLW" ██    ██ ██    ██ ██▀▀▀▀▀▀ ██    ██ ██    ▄███       ▄██ ██    ▄███ \n"RST);
    printf(YLW"  ▀████▀ ▄██████▀  ▀██▄▄██▀ ██    ██ ████████▀  ███████▀  ████████▀  \n"RST);
    printf(GRY"%s%s%s%s%s\n", "▀▀▀▀▀▀▀▀▀▀", YLW"██"RST, GRY"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"RST, YLW"█▀"RST, GRY"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"RST);
    printf(YLW"%20s%30s%s%16s%s\n", " ██" RST, GRY"║", RED" OS", GRY"║ ", uts.sysname);
    printf(YLW"%25s%29s%s%14s%s\n", " ▀▀▀▀"RST, GRY"║", RED" User", GRY"║ ", getlogin());
    printf(GRY"%37s%s%10s%s\n", "║", RED" Hostname", GRY"║ ", computer);
    printf(GRY"%37s%s%11s%s\n", "║", RED" Version", GRY"║ ", uts.release);
    printf(GRY"%37s%s%10s%s\n", "║", RED" Hardware", GRY"║ ", uts.machine);
    printf(GRY"%37s%s%13s%s\n", "║", RED" Shell", GRY"║ ", p->pw_shell);
    printf(GRY"%37s%s%11s%s\n", "║", RED" Userdir", GRY"║ ", p->pw_dir);
	count_packages();
    disk();
    printf(GRY"%37s%s%14s%s", "║", RED" Date", GRY"║ ", ctime(&timeval));
    uptime(&now);
    printf(GRY"%74s\n", "╚══════════╝"RST);
    return 0;
}
