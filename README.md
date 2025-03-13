# 深度學習之分散式訓練實作
## 課程主旨
深度學習之神經網路模型與資料日益壯大，需要多GPU環境來開發與訓練神經網路模型。本課程藉由TWCC的開發型容器(CCS)與高速計算環境(HPC)進行分散式訓練實作。

## 課程大綱
1. 深度學習之分散式訓練簡介
   1. 分散式訓練的類型 Data parallel vs Model Parallel
   2. 資料交換方式 Parameter server vs Ring-AllReduce
   3. 平行運算概論 軟體： MPI Message Passing Interface, NCCL
   4. 平行運算概論 硬體：GPUDirect, NVLink, Infiniband 
2. TWCC 多GPU開發環境簡介
   1. 開發型容器(CCS)
   2. 高速計算環境(HPC)
3. 實作
  1. Horovod 
  2. Pytorch DDP 
  3. DeepSpeed
