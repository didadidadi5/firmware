################################################################################
#
# motors
#
################################################################################

MOTORS_SITE = $(call github,openipc,motors,$(MOTORS_VERSION))
MOTORS_VERSION = HEAD

MOTORS_LICENSE = MIT
MOTORS_LICENSE_FILES = LICENSE

define MOTORS_BUILD_CMDS
	# build camhi-motor if present
	if [ -d $(@D)/camhi-motor ]; then \
		(cd $(@D)/camhi-motor && $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -Os -s main.c -o camhi-motor $(TARGET_LDFLAGS) $(TARGET_LDLIBS)); \
	fi
	# build i2c-motor if present
	if [ -d $(@D)/i2c-motor ]; then \
		(cd $(@D)/i2c-motor && $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -Os -s main.c -o i2c-motor $(TARGET_LDFLAGS) $(TARGET_LDLIBS)); \
	fi
	# build xm-kmotor if present
	if [ -d $(@D)/xm-kmotor ]; then \
		(cd $(@D)/xm-kmotor && $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -Os -s main.c -o xm-kmotor $(TARGET_LDFLAGS) $(TARGET_LDLIBS)); \
	fi
	# build xm-uart if present
	if [ -d $(@D)/xm-uart ]; then \
		(cd $(@D)/xm-uart && $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -Os -s main.c -o xm-uart $(TARGET_LDFLAGS) $(TARGET_LDLIBS)); \
	fi
	# build ingenic-motor if present
	if [ -d $(@D)/ingenic-motor ]; then \
		(cd $(@D)/ingenic-motor && $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -Os -s main.c -o ingenic-motor $(TARGET_LDFLAGS) $(TARGET_LDLIBS)); \
	fi
	# build AN41908 variant (support both an41908 and an41908a directories and several source names)
	if [ -d $(@D)/an41908 ]; then \
		(cd $(@D)/an41908 && \
			if [ -f main.c ]; then \
				$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include -Os -s main.c -o an41908 $(TARGET_LDFLAGS) $(TARGET_LDLIBS) -lm -lpthread; \
			elif [ -f an41908.c ]; then \
				$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include -Os -s an41908.c -o an41908 $(TARGET_LDFLAGS) $(TARGET_LDLIBS) -lm -lpthread; \
			elif [ -f an41908a.c ]; then \
				$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include -Os -s an41908a.c -o an41908 $(TARGET_LDFLAGS) $(TARGET_LDLIBS) -lm -lpthread; \
			fi); \
	elif [ -d $(@D)/an41908a ]; then \
		(cd $(@D)/an41908a && \
			if [ -f main.c ]; then \
				$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include -Os -s main.c -o an41908 $(TARGET_LDFLAGS) $(TARGET_LDLIBS) -lm -lpthread; \
			elif [ -f an41908a.c ]; then \
				$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include -Os -s an41908a.c -o an41908 $(TARGET_LDFLAGS) $(TARGET_LDLIBS) -lm -lpthread; \
			elif [ -f an41908.c ]; then \
				$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include -Os -s an41908.c -o an41908 $(TARGET_LDFLAGS) $(TARGET_LDLIBS) -lm -lpthread; \
			fi); \
	fi
endef

define MOTORS_INSTALL_TARGET_CMDS
	if [ -f $(@D)/camhi-motor/camhi-motor ]; then \
		$(INSTALL) -m 0755 -D $(@D)/camhi-motor/camhi-motor $(TARGET_DIR)/usr/bin/camhi-motor; \
	fi
	if [ -f $(@D)/i2c-motor/i2c-motor ]; then \
		$(INSTALL) -m 0755 -D $(@D)/i2c-motor/i2c-motor $(TARGET_DIR)/usr/bin/i2c-motor; \
	fi
	if [ -f $(@D)/xm-kmotor/xm-kmotor ]; then \
		$(INSTALL) -m 0755 -D $(@D)/xm-kmotor/xm-kmotor $(TARGET_DIR)/usr/bin/xm-kmotor; \
	fi
	if [ -f $(@D)/xm-uart/xm-uart ]; then \
		$(INSTALL) -m 0755 -D $(@D)/xm-uart/xm-uart $(TARGET_DIR)/usr/bin/xm-uart; \
	fi
	if [ -f $(@D)/ingenic-motor/ingenic-motor ]; then \
		$(INSTALL) -m 0755 -D $(@D)/ingenic-motor/ingenic-motor $(TARGET_DIR)/usr/bin/ingenic-motor; \
	fi
	# install AN41908 if built in any of the supported dirs
	if [ -f $(@D)/an41908/an41908 ]; then \
		$(INSTALL) -m 0755 -D $(@D)/an41908/an41908 $(TARGET_DIR)/usr/bin/an41908; \
	elif [ -f $(@D)/an41908a/an41908 ]; then \
		$(INSTALL) -m 0755 -D $(@D)/an41908a/an41908 $(TARGET_DIR)/usr/bin/an41908; \
	fi
endef

$(eval $(generic-package))
