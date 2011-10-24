typedef enum _ISBindingFlags {
    ISStaticBindingFlag       = 0,
    ISInstanceBindingFlag     = 1 << 0,
    ISDeclaredOnlyBindingFlag = 1 << 1
} ISBindingFlags;
