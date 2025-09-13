# 深度學習之分散式訓練實作
## 課程簡介
深度學習之神經網路模型與資料量日益壯大，需要多GPU環境來開發與訓練神經網路模型。本課程藉由國網中心的晶創25(Nano5)與台灣杉二號(Taiwania2)GPU叢集系統，進行分散式訓練實作。

## 課程大綱
1. 國網中心的超級電腦
   1. Nano5 (Nvidia H100/H200 GPU cluster)
   2. Taiwania 2(Nvidia Tesla V100 GPU cluster)
   3. iService計算資源服務網
2. HPC Cluster Software
   1. SLURM任務調度
   2. Lmod環境管理
   3. Singularity container虛擬環境管理
      * Customized image打包客製化環境
3. 案例實作
   1. Horovod 
   2. Pytorch DDP 
   3. DeepSpeed

[Setup WSL](https://hackmd.io/@ybfang/SkcA9Ifjll)
