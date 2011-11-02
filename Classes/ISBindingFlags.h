typedef enum _ISBindingFlags {
    ISStaticBindingFlag       = 1,
    ISInstanceBindingFlag     = 1 << 1,
    ISDeclaredOnlyBindingFlag = 1 << 2
} ISBindingFlags;
