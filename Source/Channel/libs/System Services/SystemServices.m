//
//  SystemServices.m
//  SystemServicesDemo
//
//  Created by Shmoopi LLC on 9/15/12.
//  Copyright (c) 2012 Shmoopi LLC. All rights reserved.
//

#import "SystemServices.h"

@interface SystemServices ()

// Get all System Information (All Methods)
- (nullable NSDictionary *)getAllSystemInformation;

@end

@implementation SystemServices

@dynamic allSystemInformation;

// Singleton
+ (nonnull instancetype)sharedServices {
    static SystemServices *sharedSystemServices = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSystemServices = [[self alloc] init];
    });
    return sharedSystemServices;
}

// System Information

- (NSString *)systemsUptime {
    return [SSHardwareInfo systemUptime];
}

- (NSString *)deviceModel {
    return [SSHardwareInfo deviceModel];
}

- (NSString *)deviceName {
    return [SSHardwareInfo deviceName];
}

- (NSString *)systemName {
    return [SSHardwareInfo systemName];
}

- (NSString *)systemsVersion {
    return [SSHardwareInfo systemVersion];
}

- (NSString *)systemDeviceTypeNotFormatted {
    return [SSHardwareInfo systemDeviceTypeFormatted:NO];
}

- (NSString *)systemDeviceTypeFormatted {
    return [SSHardwareInfo systemDeviceTypeFormatted:YES];
}

- (NSInteger)screenWidth {
    return [SSHardwareInfo screenWidth];
}

- (NSInteger)screenHeight {
    return [SSHardwareInfo screenHeight];
}

- (float)screenBrightness {
    return [SSHardwareInfo screenBrightness];
}

- (NSString *)carrierName {
    return [SSCarrierInfo carrierName];
}

- (NSString *)carrierCountry {
    return [SSCarrierInfo carrierCountry];
}

- (int)processID {
    return [SSProcessInfo processID];
}

- (NSString *)diskSpace {
    return [SSDiskInfo diskSpace];
}

- (NSString *)freeDiskSpaceinRaw {
    return [SSDiskInfo freeDiskSpace:NO];
}

- (NSString *)freeDiskSpaceinPercent {
    return [SSDiskInfo freeDiskSpace:YES];
}

- (NSString *)usedDiskSpaceinRaw {
    return [SSDiskInfo usedDiskSpace:NO];
}

- (NSString *)usedDiskSpaceinPercent {
    return [SSDiskInfo usedDiskSpace:YES];
}

- (long long)longDiskSpace {
    return [SSDiskInfo longDiskSpace];
}

- (long long)longFreeDiskSpace {
    return [SSDiskInfo longFreeDiskSpace];
}

- (double)totalMemory {
    return [SSMemoryInfo totalMemory];
}

- (double)freeMemoryinRaw {
    return [SSMemoryInfo freeMemory:NO];
}

- (double)freeMemoryinPercent {
    return [SSMemoryInfo freeMemory:YES];
}

- (double)usedMemoryinRaw {
    return [SSMemoryInfo usedMemory:NO];
}

- (double)usedMemoryinPercent {
    return [SSMemoryInfo usedMemory:YES];
}

- (double)activeMemoryinRaw {
    return [SSMemoryInfo activeMemory:NO];
}

- (double)activeMemoryinPercent {
    return [SSMemoryInfo activeMemory:YES];
}

- (double)inactiveMemoryinRaw {
    return [SSMemoryInfo inactiveMemory:NO];
}

- (double)inactiveMemoryinPercent {
    return [SSMemoryInfo inactiveMemory:YES];
}

- (double)wiredMemoryinRaw {
    return [SSMemoryInfo wiredMemory:NO];
}

- (double)wiredMemoryinPercent {
    return [SSMemoryInfo wiredMemory:YES];
}

- (double)purgableMemoryinRaw {
    return [SSMemoryInfo purgableMemory:NO];
}

- (double)purgableMemoryinPercent {
    return [SSMemoryInfo purgableMemory:YES];
}

- (UIInterfaceOrientation)deviceOrientation {
    return [SSAccelerometerInfo deviceOrientation];
}

- (NSString *)country {
    return [SSLocalizationInfo country];
}

- (NSString *)language {
    return [SSLocalizationInfo language];
}

- (NSString *)timeZoneSS {
    return [SSLocalizationInfo timeZone];
}

- (NSString *)currency {
    return [SSLocalizationInfo currency];
}

- (NSString *)applicationVersion {
    return [SSApplicationInfo applicationVersion];
}


- (NSString *)cfuuid {
    return [SSUUID cfuuid];
}

- (float)applicationCPUUsage {
    return [SSApplicationInfo cpuUsage];
}

- (NSDictionary *)allSystemInformation {
    return [self getAllSystemInformation];
}

// Private //

// Get all System Information (All Methods)
- (NSDictionary *)getAllSystemInformation {
    
    // Create a dictionary
    NSDictionary *systemInformationDict;
    
    // Set up all System Values
    NSString *systemUptime = [self systemsUptime];
    NSString *deviceModel = [self deviceModel];
    NSString *deviceName = [self deviceName];
    NSString *systemName = [self systemName];
    NSString *systemVersion = [self systemsVersion];
    NSString *systemDeviceTypeFormattedNO = [self systemDeviceTypeNotFormatted];
    NSString *systemDeviceTypeFormattedYES = [self systemDeviceTypeFormatted];
    NSString *screenWidth = [NSString stringWithFormat:@"%ld", (long)[self screenWidth]];
    NSString *screenHeight = [NSString stringWithFormat:@"%ld", (long)[self screenHeight]];
    NSString *screenBrightness = [NSString stringWithFormat:@"%f", [self screenBrightness]];
    NSString *carrierName = [self carrierName];
    NSString *carrierCountry = [self carrierCountry];
    NSString *country = [self country];
    NSString *language = [self language];
    NSString *timeZone = [self timeZoneSS];
    NSString *currency = [self currency];
    NSString *applicationVersion = [self applicationVersion];
    NSString *cFUUID = [self cfuuid];
    NSString *cPUUsage = [NSString stringWithFormat:@"%f", [self applicationCPUUsage]];
    
    // Check to make sure all values are valid (if not, make them)
    if (systemUptime == nil || systemUptime.length <= 0) {
        // Invalid value
        systemUptime = @"Unknown";
    }
    if (deviceModel == nil || deviceModel.length <= 0) {
        // Invalid value
        deviceModel = @"Unknown";
    }
    if (deviceName == nil || deviceName.length <= 0) {
        // Invalid value
        deviceName = @"Unknown";
    }
    if (systemName == nil || systemName.length <= 0) {
        // Invalid value
        systemName = @"Unknown";
    }
    if (systemVersion == nil || systemVersion.length <= 0) {
        // Invalid value
        systemVersion = @"Unknown";
    }
    if (systemDeviceTypeFormattedNO == nil || systemDeviceTypeFormattedNO.length <= 0) {
        // Invalid value
        systemDeviceTypeFormattedNO = @"Unknown";
    }
    if (systemDeviceTypeFormattedYES == nil || systemDeviceTypeFormattedYES.length <= 0) {
        // Invalid value
        systemDeviceTypeFormattedYES = @"Unknown";
    }
    if (screenWidth == nil || screenWidth.length <= 0) {
        // Invalid value
        screenWidth = @"Unknown";
    }
    if (screenHeight == nil || screenHeight.length <= 0) {
        // Invalid value
        screenHeight = @"Unknown";
    }
    if (screenBrightness == nil || screenBrightness.length <= 0) {
        // Invalid value
        screenBrightness = @"Unknown";
    }

    if (carrierName == nil || carrierName.length <= 0) {
        // Invalid value
        carrierName = @"Unknown";
    }
    if (carrierCountry == nil || carrierCountry.length <= 0) {
        // Invalid value
        carrierCountry = @"Unknown";
    }
    if (country == nil || country.length <= 0) {
        // Invalid value
        country = @"Unknown";
    }
    if (language == nil || language.length <= 0) {
        // Invalid value
        language = @"Unknown";
    }
    if (timeZone == nil || timeZone.length <= 0) {
        // Invalid value
        timeZone = @"Unknown";
    }
    if (currency == nil || currency.length <= 0) {
        // Invalid value
        currency = @"Unknown";
    }
    if (applicationVersion == nil || applicationVersion.length <= 0) {
        // Invalid value
        applicationVersion = @"Unknown";
    }
    if (cFUUID == nil || cFUUID.length <= 0) {
        // Invalid value
        cFUUID = @"Unknown";
    }
    if (cPUUsage == nil || cPUUsage.length <= 0) {
        // Invalid value
        cPUUsage = @"Unknown";
    }
    
    // Get all Information in a dictionary
    systemInformationDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                 systemUptime,
                                                                 deviceModel,
                                                                 deviceName,
                                                                 systemName,
                                                                 systemVersion,
                                                                 systemDeviceTypeFormattedNO,
                                                                 systemDeviceTypeFormattedYES,
                                                                 screenWidth,
                                                                 screenHeight,
                                                                 screenBrightness,
                                                                 carrierName,
                                                                 carrierCountry,
                                                                 country,
                                                                 language,
                                                                 timeZone,
                                                                 currency,
                                                                 applicationVersion,
                                                                 cFUUID,
                                                                 cPUUsage,
                                                                 nil]
                                                        forKeys:[NSArray arrayWithObjects:
                                                                 @"Uptime (dd hh mm)",
                                                                 @"DeviceModel",
                                                                 @"DeviceName",
                                                                 @"SystemName",
                                                                 @" ",
                                                                 @"SystemDeviceType",
                                                                 @"SystemDeviceType Formatted",
                                                                 @"ScreenWidth",
                                                                 @"ScreenHeight",
                                                                 @"ScreenBrightness",
                                                                 @"CarrierName",
                                                                 @"CarrierCountry",
                                                                 @"Country",
                                                                 @"Language",
                                                                 @"TimeZone",
                                                                 @"Currency",
                                                                 @"ApplicationVersion",
                                                                 @"CFUUID",
                                                                 @"CPUUsage",
                                                                 nil]];
    
    // Check if Dictionary is populated
    if (systemInformationDict.count <= 0) {
        // Error, Dictionary is empty
        return nil;
    }
    
    // Successful
    return systemInformationDict;
}

@end
