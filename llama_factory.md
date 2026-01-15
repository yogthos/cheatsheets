dependencies

```bash
apt install screen
pip install -e .[metrics,bitsandbytes,qwen]
```

needed files

```bash
scp -P <port> qwen25_32b_lora.yaml root@<pod>:/workspace/LLaMA-Factory/
scp -P <port> dataset_info.json root@<pod>:/workspace/LLaMA-Factory/data/
scp -P <port> train_sft.jsonl root@<pod>:/workspace/LLaMA-Factory/data/training/<author>/train_sft.jsonl
```

### IMPORTANT: use secreen to start training!

start the training
```bash
screen -S training
CUDA_VISIBLE_DEVICES=0 llamafactory-cli train qwen25_32b_lora.yaml
```
* Detach: Press `Ctrl + A`, then `D`.
* Re-attach: `screen -r training`

Setting `CUDA_VISIBLE_DEVICES=0` says to ignore every other GPU in this machine and only look at the first one
