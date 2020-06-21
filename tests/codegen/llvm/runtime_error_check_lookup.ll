; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf-pc-linux"

%helper_error_t = type <{ i64, i64, i32 }>

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64, i64) #0

define i64 @"kprobe:f"(i8*) section "s_kprobe:f_1" {
entry:
  %helper_error_t3 = alloca %helper_error_t
  %"@_newval" = alloca i64
  %helper_error_t = alloca %helper_error_t
  %lookup_elem_val = alloca i64
  %"@_key" = alloca i64
  %1 = bitcast i64* %"@_key" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
  store i64 0, i64* %"@_key"
  %pseudo = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %lookup_elem = call i8* inttoptr (i64 1 to i8* (i64, i64*)*)(i64 %pseudo, i64* %"@_key")
  %2 = bitcast i64* %lookup_elem_val to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %2)
  %map_lookup_cond = icmp ne i8* %lookup_elem, null
  br i1 %map_lookup_cond, label %lookup_success, label %lookup_failure

lookup_success:                                   ; preds = %entry
  %cast = bitcast i8* %lookup_elem to i64*
  %3 = load i64, i64* %cast
  store i64 %3, i64* %lookup_elem_val
  br label %lookup_merge

lookup_failure:                                   ; preds = %entry
  store i64 0, i64* %lookup_elem_val
  %4 = bitcast %helper_error_t* %helper_error_t to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %4)
  %5 = getelementptr %helper_error_t, %helper_error_t* %helper_error_t, i64 0, i32 0
  store i64 30006, i64* %5
  %6 = getelementptr %helper_error_t, %helper_error_t* %helper_error_t, i64 0, i32 1
  store i64 0, i64* %6
  %7 = getelementptr %helper_error_t, %helper_error_t* %helper_error_t, i64 0, i32 2
  store i32 0, i32* %7
  %pseudo1 = call i64 @llvm.bpf.pseudo(i64 1, i64 2)
  %get_cpu_id = call i64 inttoptr (i64 8 to i64 ()*)()
  %perf_event_output = call i64 inttoptr (i64 25 to i64 (i8*, i64, i64, %helper_error_t*, i64)*)(i8* %0, i64 %pseudo1, i64 %get_cpu_id, %helper_error_t* %helper_error_t, i64 20)
  %8 = bitcast %helper_error_t* %helper_error_t to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %8)
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure, %lookup_success
  %9 = load i64, i64* %lookup_elem_val
  %10 = bitcast i64* %"@_newval" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %10)
  %11 = add i64 %9, 1
  store i64 %11, i64* %"@_newval"
  %pseudo2 = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %update_elem = call i64 inttoptr (i64 2 to i64 (i64, i64*, i64*, i64)*)(i64 %pseudo2, i64* %"@_key", i64* %"@_newval", i64 0)
  %12 = trunc i64 %update_elem to i32
  %13 = icmp sge i32 %12, 0
  br i1 %13, label %helper_merge, label %helper_failure

helper_failure:                                   ; preds = %lookup_merge
  %14 = bitcast %helper_error_t* %helper_error_t3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %14)
  %15 = getelementptr %helper_error_t, %helper_error_t* %helper_error_t3, i64 0, i32 0
  store i64 30006, i64* %15
  %16 = getelementptr %helper_error_t, %helper_error_t* %helper_error_t3, i64 0, i32 1
  store i64 1, i64* %16
  %17 = getelementptr %helper_error_t, %helper_error_t* %helper_error_t3, i64 0, i32 2
  store i32 %12, i32* %17
  %pseudo4 = call i64 @llvm.bpf.pseudo(i64 1, i64 2)
  %get_cpu_id5 = call i64 inttoptr (i64 8 to i64 ()*)()
  %perf_event_output6 = call i64 inttoptr (i64 25 to i64 (i8*, i64, i64, %helper_error_t*, i64)*)(i8* %0, i64 %pseudo4, i64 %get_cpu_id5, %helper_error_t* %helper_error_t3, i64 20)
  %18 = bitcast %helper_error_t* %helper_error_t3 to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %18)
  br label %helper_merge

helper_merge:                                     ; preds = %helper_failure, %lookup_merge
  %19 = bitcast i64* %"@_key" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %19)
  %20 = bitcast i64* %"@_newval" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %20)
  ret i64 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }
