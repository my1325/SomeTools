
#import <Foundation/Foundation.h>

#import "LCGPBUtilities.h"

#import "LCGPBDescriptor_PackagePrivate.h"

#define LCGPBStringify(S) #S
#define LCGPBStringifySymbol(S) LCGPBStringify(S)

#define LCGPBNSStringify(S) @#S
#define LCGPBNSStringifySymbol(S) LCGPBNSStringify(S)

#define LCGPBObjCClassSymbol(name) OBJC_CLASS_$_##name
#define LCGPBObjCClass(name) \
    ((__bridge Class)&(LCGPBObjCClassSymbol(name)))
#define LCGPBObjCClassDeclaration(name) \
    extern const LCGPBObjcClass_t LCGPBObjCClassSymbol(name)

// Constant to internally mark when there is no has bit.
#define LCGPBNoHasBit INT32_MAX

CF_EXTERN_C_BEGIN

// These two are used to inject a runtime check for version mismatch into the
// generated sources to make sure they are linked with a supporting runtime.
void LCGPBCheckRuntimeVersionSupport(int32_t objcRuntimeVersion);
LCGPB_INLINE void LCGPB_DEBUG_CHECK_RUNTIME_VERSIONS() {
#if defined(DEBUG) && DEBUG
  LCGPBCheckRuntimeVersionSupport(GOOGLE_PROTOBUF_OBJC_VERSION);
#endif
}

void LCGPBCheckRuntimeVersionInternal(int32_t version);
LCGPB_INLINE void LCGPBDebugCheckRuntimeVersion() {
#if defined(DEBUG) && DEBUG
  LCGPBCheckRuntimeVersionInternal(GOOGLE_PROTOBUF_OBJC_GEN_VERSION);
#endif
}


LCGPB_INLINE int64_t LCGPBConvertDoubleToInt64(double v) {
  LCGPBInternalCompileAssert(sizeof(double) == sizeof(int64_t), double_not_64_bits);
  int64_t result;
  memcpy(&result, &v, sizeof(result));
  return result;
}

LCGPB_INLINE int32_t LCGPBConvertFloatToInt32(float v) {
  LCGPBInternalCompileAssert(sizeof(float) == sizeof(int32_t), float_not_32_bits);
  int32_t result;
  memcpy(&result, &v, sizeof(result));
  return result;
}

LCGPB_INLINE double LCGPBConvertInt64ToDouble(int64_t v) {
  LCGPBInternalCompileAssert(sizeof(double) == sizeof(int64_t), double_not_64_bits);
  double result;
  memcpy(&result, &v, sizeof(result));
  return result;
}

LCGPB_INLINE float LCGPBConvertInt32ToFloat(int32_t v) {
  LCGPBInternalCompileAssert(sizeof(float) == sizeof(int32_t), float_not_32_bits);
  float result;
  memcpy(&result, &v, sizeof(result));
  return result;
}

LCGPB_INLINE int32_t LCGPBLogicalRightShift32(int32_t value, int32_t spaces) {
  return (int32_t)((uint32_t)(value) >> spaces);
}

LCGPB_INLINE int64_t LCGPBLogicalRightShift64(int64_t value, int32_t spaces) {
  return (int64_t)((uint64_t)(value) >> spaces);
}

LCGPB_INLINE int32_t LCGPBDecodeZigZag32(uint32_t n) {
  return (int32_t)(LCGPBLogicalRightShift32((int32_t)n, 1) ^ -((int32_t)(n) & 1));
}

LCGPB_INLINE int64_t LCGPBDecodeZigZag64(uint64_t n) {
  return (int64_t)(LCGPBLogicalRightShift64((int64_t)n, 1) ^ -((int64_t)(n) & 1));
}

LCGPB_INLINE uint32_t LCGPBEncodeZigZag32(int32_t n) {
  return ((uint32_t)n << 1) ^ (uint32_t)(n >> 31);
}

LCGPB_INLINE uint64_t LCGPBEncodeZigZag64(int64_t n) {
  return ((uint64_t)n << 1) ^ (uint64_t)(n >> 63);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch-enum"
#pragma clang diagnostic ignored "-Wdirect-ivar-access"

LCGPB_INLINE BOOL LCGPBDataTypeIsObject(LCGPBDataType type) {
  switch (type) {
    case LCGPBDataTypeBytes:
    case LCGPBDataTypeString:
    case LCGPBDataTypeMessage:
    case LCGPBDataTypeGroup:
      return YES;
    default:
      return NO;
  }
}

LCGPB_INLINE BOOL LCGPBDataTypeIsMessage(LCGPBDataType type) {
  switch (type) {
    case LCGPBDataTypeMessage:
    case LCGPBDataTypeGroup:
      return YES;
    default:
      return NO;
  }
}

LCGPB_INLINE BOOL LCGPBFieldDataTypeIsMessage(LCGPBFieldDescriptor *field) {
  return LCGPBDataTypeIsMessage(field->description_->dataType);
}

LCGPB_INLINE BOOL LCGPBFieldDataTypeIsObject(LCGPBFieldDescriptor *field) {
  return LCGPBDataTypeIsObject(field->description_->dataType);
}

LCGPB_INLINE BOOL LCGPBExtensionIsMessage(LCGPBExtensionDescriptor *ext) {
  return LCGPBDataTypeIsMessage(ext->description_->dataType);
}

LCGPB_INLINE BOOL LCGPBFieldStoresObject(LCGPBFieldDescriptor *field) {
  LCGPBMessageFieldDescription *desc = field->description_;
  if ((desc->flags & (LCGPBFieldRepeated | LCGPBFieldMapKeyMask)) != 0) {
    return YES;
  }
  return LCGPBDataTypeIsObject(desc->dataType);
}

BOOL LCGPBGetHasIvar(LCGPBMessage *self, int32_t index, uint32_t fieldNumber);
void LCGPBSetHasIvar(LCGPBMessage *self, int32_t idx, uint32_t fieldNumber,
                   BOOL value);
uint32_t LCGPBGetHasOneof(LCGPBMessage *self, int32_t index);

LCGPB_INLINE BOOL
LCGPBGetHasIvarField(LCGPBMessage *self, LCGPBFieldDescriptor *field) {
  LCGPBMessageFieldDescription *fieldDesc = field->description_;
  return LCGPBGetHasIvar(self, fieldDesc->hasIndex, fieldDesc->number);
}

#pragma clang diagnostic pop


void LCGPBSetBoolIvarWithFieldPrivate(LCGPBMessage *self,
                                    LCGPBFieldDescriptor *field,
                                    BOOL value);

void LCGPBSetInt32IvarWithFieldPrivate(LCGPBMessage *self,
                                     LCGPBFieldDescriptor *field,
                                     int32_t value);

void LCGPBSetUInt32IvarWithFieldPrivate(LCGPBMessage *self,
                                      LCGPBFieldDescriptor *field,
                                      uint32_t value);

void LCGPBSetInt64IvarWithFieldPrivate(LCGPBMessage *self,
                                     LCGPBFieldDescriptor *field,
                                     int64_t value);

void LCGPBSetUInt64IvarWithFieldPrivate(LCGPBMessage *self,
                                      LCGPBFieldDescriptor *field,
                                      uint64_t value);

void LCGPBSetFloatIvarWithFieldPrivate(LCGPBMessage *self,
                                     LCGPBFieldDescriptor *field,
                                     float value);

void LCGPBSetDoubleIvarWithFieldPrivate(LCGPBMessage *self,
                                      LCGPBFieldDescriptor *field,
                                      double value);

void LCGPBSetEnumIvarWithFieldPrivate(LCGPBMessage *self,
                                    LCGPBFieldDescriptor *field,
                                    int32_t value);

id LCGPBGetObjectIvarWithField(LCGPBMessage *self, LCGPBFieldDescriptor *field);

void LCGPBSetObjectIvarWithFieldPrivate(LCGPBMessage *self,
                                      LCGPBFieldDescriptor *field, id value);
void LCGPBSetRetainedObjectIvarWithFieldPrivate(LCGPBMessage *self,
                                              LCGPBFieldDescriptor *field,
                                              id __attribute__((ns_consumed))
                                              value);

id LCGPBGetObjectIvarWithFieldNoAutocreate(LCGPBMessage *self,
                                         LCGPBFieldDescriptor *field);

void LCGPBClearAutocreatedMessageIvarWithField(LCGPBMessage *self,
                                             LCGPBFieldDescriptor *field);

const char *LCGPBMessageEncodingForSelector(SEL selector, BOOL instanceSel);

NSString *LCGPBDecodeTextFormatName(const uint8_t *decodeData, int32_t key,
                                  NSString *inputString);


void LCGPBSetInt32IvarWithFieldInternal(LCGPBMessage *self,
                                      LCGPBFieldDescriptor *field,
                                      int32_t value,
                                      LCGPBFileSyntax syntax);
void LCGPBMaybeClearOneof(LCGPBMessage *self, LCGPBOneofDescriptor *oneof,
                        int32_t oneofHasIndex, uint32_t fieldNumberNotToClear);

@protocol LCGPBMessageSignatureProtocol
#define LCGPB_MESSAGE_SIGNATURE_ENTRY(TYPE, NAME) \
  -(TYPE)get##NAME;                             \
  -(void)set##NAME : (TYPE)value;               \
  -(TYPE)get##NAME##AtIndex : (NSUInteger)index;
@optional
LCGPB_MESSAGE_SIGNATURE_ENTRY(uint64_t, UInt64)
LCGPB_MESSAGE_SIGNATURE_ENTRY(uint64_t, Fixed64)
LCGPB_MESSAGE_SIGNATURE_ENTRY(int32_t, SFixed32)
LCGPB_MESSAGE_SIGNATURE_ENTRY(int64_t, SFixed64)
LCGPB_MESSAGE_SIGNATURE_ENTRY(int64_t, SInt64)
LCGPB_MESSAGE_SIGNATURE_ENTRY(float, Float)
LCGPB_MESSAGE_SIGNATURE_ENTRY(int32_t, SInt32)
+ (id)getClassValue;
- (id)getArray;
LCGPB_MESSAGE_SIGNATURE_ENTRY(uint32_t, Fixed32)

LCGPB_MESSAGE_SIGNATURE_ENTRY(LCGPBMessage *, Group)
LCGPB_MESSAGE_SIGNATURE_ENTRY(int32_t, Enum)

LCGPB_MESSAGE_SIGNATURE_ENTRY(uint32_t, UInt32)
LCGPB_MESSAGE_SIGNATURE_ENTRY(double, Double)

LCGPB_MESSAGE_SIGNATURE_ENTRY(NSString *, String)

LCGPB_MESSAGE_SIGNATURE_ENTRY(int64_t, Int64)
LCGPB_MESSAGE_SIGNATURE_ENTRY(BOOL, Bool)
LCGPB_MESSAGE_SIGNATURE_ENTRY(int32_t, Int32)
- (void)setArray:(NSArray *)array;
LCGPB_MESSAGE_SIGNATURE_ENTRY(LCGPBMessage *, Message)
- (NSUInteger)getArrayCount;
LCGPB_MESSAGE_SIGNATURE_ENTRY(NSData *, Bytes)
@end

BOOL LCGPBClassHasSel(Class aClass, SEL sel);

CF_EXTERN_C_END
