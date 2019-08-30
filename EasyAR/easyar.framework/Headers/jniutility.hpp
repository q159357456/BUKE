//=============================================================================================================================
//
// EasyAR 3.0.0-final-r47287f89
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_JNIUTILITY_HPP__
#define __EASYAR_JNIUTILITY_HPP__

#include "easyar/types.hpp"

namespace easyar {

class JniUtility
{
public:
    static std::shared_ptr<Buffer> wrapByteArray(void * bytes, bool readOnly, std::function<void()> deleter);
    static std::shared_ptr<Buffer> wrapBuffer(void * directBuffer, std::function<void()> deleter);
};

#ifndef __EASYAR_FUNCTOROFVOID__
#define __EASYAR_FUNCTOROFVOID__
static void FunctorOfVoid_func(void * _state, /* OUT */ easyar_String * * _exception);
static void FunctorOfVoid_destroy(void * _state);
static inline easyar_FunctorOfVoid FunctorOfVoid_to_c(std::function<void()> f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_JNIUTILITY_HPP__
#define __IMPLEMENTATION_EASYAR_JNIUTILITY_HPP__

#include "easyar/jniutility.h"
#include "easyar/buffer.hpp"

namespace easyar {

inline std::shared_ptr<Buffer> JniUtility::wrapByteArray(void * arg0, bool arg1, std::function<void()> arg2)
{
    easyar_Buffer * _return_value_;
    easyar_JniUtility_wrapByteArray(arg0, arg1, FunctorOfVoid_to_c(arg2), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Buffer>(std::shared_ptr<easyar_Buffer>(_return_value_, [](easyar_Buffer * ptr) { easyar_Buffer__dtor(ptr); })));
}
inline std::shared_ptr<Buffer> JniUtility::wrapBuffer(void * arg0, std::function<void()> arg1)
{
    easyar_Buffer * _return_value_;
    easyar_JniUtility_wrapBuffer(arg0, FunctorOfVoid_to_c(arg1), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Buffer>(std::shared_ptr<easyar_Buffer>(_return_value_, [](easyar_Buffer * ptr) { easyar_Buffer__dtor(ptr); })));
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOID__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOID__
static void FunctorOfVoid_func(void * _state, /* OUT */ easyar_String * * _exception)
{
    *_exception = nullptr;
    try {
        auto f = reinterpret_cast<std::function<void()> *>(_state);
        (*f)();
    } catch (std::exception & ex) {
        auto message = std::string() + typeid(*(&ex)).name() + u8"\n" + ex.what();
        easyar_String_from_utf8_begin(message.c_str(), _exception);
    }
}
static void FunctorOfVoid_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void()> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoid FunctorOfVoid_to_c(std::function<void()> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoid{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoid{new std::function<void()>(f), FunctorOfVoid_func, FunctorOfVoid_destroy};
}
#endif

}

#endif
