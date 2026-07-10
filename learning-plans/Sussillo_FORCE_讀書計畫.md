# David Sussillo FORCE algorithm 與 Computation Through Dynamics 讀書計畫

整理日期：2026-05-09

掃描範圍：C 槽使用者文件區，包含 `C:\Users\User\Documents`、`C:\Users\User\Downloads`、`C:\Users\User\Desktop`。全 C 槽系統層級遞迴搜尋未回傳可用結果，因此本清單以使用者文件區中找到的檔案為主。

## 一、研讀主軸

本次讀書計畫不是把 Computational Neuroscience 全部重讀，而是聚焦一條主線：

1. 從非線性動力系統理解 RNN。
2. 從 reservoir computing 進入 FORCE learning。
3. 用 Sussillo 路線理解混沌 RNN 如何被訓練成穩定、可解釋的動態系統。
4. 再把 RNN 分析方法接到神經群體動力學、motor cortex、PFC、多任務計算與 NeuroAI。

核心問題：

- FORCE 解決了什麼 RNN 訓練問題？
- reservoir computing、echo state network、FORCE 的差別是什麼？
- 為什麼 Sussillo 會把 RNN 當作大腦運算的機制模型，而不是只當 AI 工具？
- fixed point、slow point、attractor、low-dimensional manifold 如何讓黑盒 RNN 變成可解釋模型？
- Churchland motor cortex population dynamics、Driscoll/Sussillo multitask RNN、Yang 多任務網路如何共同支持 Computation Through Dynamics？

## 二、C 槽中找到的核心文獻與書籍

### A. 必讀：直接進入 Sussillo 路線

1. `C:\Users\User\Documents\New project 2\David_Sussillo_NotebookLM_幻燈片分析整理.md`
   - 角色：總覽地圖。
   - 用法：先讀，建立 FORCE、RNN、reservoir computing、fixed point analysis、Computation Through Dynamics 的關係圖。

2. `C:\Users\User\Downloads\MicrosoftEdgeDropFiles\Default\Driscoll_Sussilo_2022_Flexible multitask computation in recurrent networks utilizes shared dynamical motifs.pdf`
   - 角色：Sussillo 近年核心應用。
   - 用法：重點看 shared dynamical motifs、多任務 RNN、PFC 彈性計算。
   - 優先級：最高。

3. `C:\Users\User\Downloads\MicrosoftEdgeDropFiles\Default\Yang_2019_Task representations in neural networks trained to perform many.pdf`
   - 角色：多任務 RNN 與任務表徵。
   - 用法：搭配 Driscoll/Sussillo 讀，理解 context、task representation、network dynamics。
   - 優先級：高。

4. `C:\Users\User\Downloads\MicrosoftEdgeDropFiles\Default\Churchland_2012_Neural population dynamics during reaching.pdf`
   - 角色：神經群體動力學的實驗支柱。
   - 用法：重點看 motor cortex activity 被解讀為 population trajectory，而不是單一神經元編碼。
   - 優先級：高。

### B. 必讀：計算神經科學基礎

5. `C:\Users\User\Downloads\Documents\Peter Dayan, L. F. Abbott - Theoretical Neuroscience_ Computational and Mathematical Modeling of Neural Systems-The MIT Press (2005).pdf`
   - 角色：理論神經科學經典基礎。
   - 用法：挑讀神經編碼、網路模型、突觸可塑性與決策相關章節。

6. `C:\Users\User\Downloads\Documents\Thomas Trappenberg - Fundamentals of Computational Neuroscience-Oxford University Press (2023).pdf`
   - 角色：較新、較教科書式的入門主線。
   - 用法：補齊 rate model、spiking model、network dynamics、learning。

7. `C:\Users\User\Downloads\Documents\Xiao-Jing Wang - Theoretical Neuroscience_ Understanding Cognition (2025, CRC Press) - libgen.li.pdf`
   - 角色：認知層次的 theoretical neuroscience。
   - 用法：用來把 working memory、decision making、cortical circuit 和 Sussillo 的 PFC/RNN 路線接起來。

8. `C:\Users\User\Downloads\Documents\Ranu Jung (editor)_ Dieter Jäger (editor) - Encyclopedia of computational neuroscience (2022).pdf`
   - 角色：查字典。
   - 用法：遇到 unfamiliar terms 時查 fixed point、attractor、reservoir computing、population coding、RNN 等條目。

### C. 必讀：動力系統與資料驅動分析

9. `C:\Users\User\Downloads\Documents\Steven H. Strogatz - Nonlinear Dynamics and Chaos-CRC Press (2024).pdf`
   - 角色：理解 fixed point、stability、bifurcation、limit cycle、chaos 的數學基礎。
   - 用法：優先讀 fixed point、linear stability、limit cycle、chaos，不必從頭全讀。

10. `C:\Users\User\Downloads\Documents\Steven L. Brunton, J. Nathan Kutz - Data-Driven Science and Engineering_ Machine Learning, Dynamical Systems, and Control 2nd Edition, Kindle Edition (2022, Cambridge University Press) - libgen.li.pdf`
    - 角色：把高維資料、降維、動力系統識別與控制接到神經資料分析。
    - 用法：重點看 PCA/SVD、dynamic mode decomposition、sparse identification、control。

11. `C:\Users\User\Downloads\[PoliTO Springer Series ] Fernando Corinto, Alessandro Torcini - Nonlinear Dynamics in Computational Neuroscience (2019, Springer) [10.1007_978-3-319-71048-8] - libgen.li.pdf`
    - 角色：非線性動力學在神經科學中的專門應用。
    - 用法：作為 Strogatz 和 computational neuroscience 之間的橋接。

### D. 延伸：與神經振盪、群體活動、BCI、臨床神經動力學相關

12. `C:\Users\User\Downloads\Documents\wang-2010-neurophysiological-and-computational-principles-of-cortical-rhythms-in-cognition.pdf`
    - 用法：理解 cortical rhythm 與 cognition 的計算原理。

13. `C:\Users\User\Downloads\Documents\Spiking_Foundation_Models_for_BCI_sildes.pdf`
    - 用法：補 NeuroAI/BCI 脈絡，非第一優先。

14. `C:\Users\User\Downloads\Miguel A. L. Nicolelis (Editor) - Methods for Neural Ensemble Recordings (2007, CRC Press) [10.1201_9781420006414] - libgen.li.pdf`
    - 用法：理解 neural ensemble recording 的資料背景。

15. `C:\Users\User\Downloads\Xiaoli Li (eds.) - Signal Processing in Neuroscience (2016, Springer) [10.1007_978-981-10-1822-0] - libgen.li.pdf`
    - 用法：補訊號處理與神經資料分析。

16. `C:\Users\User\Desktop\eBook\Charlotte Nassim_ Eva Marder - Lessons from the lobster _ Eve Marder's work in neuroscience-The MIT Press (2018).pdf`
    - 用法：用 Marder 的小型神經迴路動力學理解 biological realism，作為批判 FORCE rate-RNN 的對照。

## 三、閱讀順序

### 第 0 階段：先建立地圖，1 天

讀：

- `David_Sussillo_NotebookLM_幻燈片分析整理.md`

輸出：

- 畫一張概念圖：Reservoir computing -> FORCE -> trainable chaotic RNN -> fixed point analysis -> neural population dynamics -> Computation Through Dynamics。
- 寫 10 個你目前最不懂的詞。

### 第 1 階段：補數學直覺，3-4 天

讀：

- Strogatz：fixed point、linear stability、bifurcation、limit cycle、chaos。
- Trappenberg：rate model、network dynamics、learning。

目標：

- 能看懂「RNN 的狀態是高維動力系統」這句話。
- 能用自己的話說明 fixed point、slow point、attractor、trajectory。

### 第 2 階段：進入 FORCE 與 reservoir computing，4-5 天

讀：

- Dayan & Abbott 中的 network/modeling 相關章節。
- Trappenberg 中的 recurrent network / learning 章節。
- NotebookLM 整理中 FORCE、reservoir computing、RNN 的段落。

目標：

- 弄清楚 reservoir computing 只訓練 readout 的限制。
- 弄清楚 FORCE 的核心是用 RLS 快速穩定混沌 RNN 的 closed-loop dynamics。
- 做一張比較表：ESN/reservoir computing、FORCE、BPTT-trained RNN。

### 第 3 階段：讀 Sussillo 相關實證與模型，1 週

讀：

- Driscoll/Sussillo 2022 multitask computation。
- Yang 2019 task representations。
- Churchland 2012 motor cortex population dynamics。

閱讀策略：

- 不要先陷入每個統計方法；先抓「任務、資料、模型、動力學解釋」四件事。
- 每篇都用同一模板摘要：
  - 問題：作者想解釋什麼神經或行為現象？
  - 模型：用了什麼 RNN 或資料分析方法？
  - 動力學：fixed point、trajectory、manifold、motif 出現在哪裡？
  - 神經意義：這是否真的解釋了大腦，還是只是工程類比？

### 第 4 階段：從理解到批判，1 週

讀：

- Xiao-Jing Wang：working memory、decision making、cognitive circuit。
- Brunton & Kutz：PCA/SVD、DMD、data-driven dynamics。
- Marder 相關材料：biological realism、small circuits、degeneracy。

目標：

- 批判 FORCE 的生物可實作性。
- 批判 low-dimensional manifold 是否過度簡化。
- 比較 Sussillo 動力學路線與 Transformer/NeuroAI 大模型路線。

## 四、兩週讀書計畫

每日 90-150 分鐘。這版把重點壓縮到「先有動力系統直覺，再讀 FORCE 與 Sussillo 相關論文，最後輸出整合報告」。

### Week 1：建立底盤，進入 FORCE

- Day 1：讀 `David_Sussillo_NotebookLM_幻燈片分析整理.md`，畫總概念圖：Reservoir computing -> FORCE -> RNN -> fixed point -> neural population dynamics -> CTD。
- Day 2：讀 Strogatz 的 fixed point、linear stability、attractor；輸出一頁詞彙表。
- Day 3：讀 Strogatz 的 limit cycle、chaos，加讀 Trappenberg 的 rate model / network dynamics。
- Day 4：讀 Trappenberg 或 Dayan & Abbott 的 recurrent network 相關章節；整理 RNN 為何可被視為高維動力系統。
- Day 5：整理 ESN/reservoir computing 與 FORCE 的差異；做 `ESN vs FORCE vs BPTT-trained RNN` 比較表。
- Day 6：集中理解 FORCE：RLS、closed-loop feedback、chaotic RNN stabilization；寫一頁「FORCE 到底解決什麼問題」。
- Day 7：回顧補洞；完成一頁「我如何理解 Computation Through Dynamics」。

### Week 2：讀核心論文，完成整合

- Day 8：讀 Churchland 2012 摘要、主要圖與討論；整理 motor cortex population trajectory。
- Day 9：完成 Churchland 2012 筆記；畫 `single-neuron coding vs population dynamics` 對照圖。
- Day 10：讀 Yang 2019 摘要、主要圖與討論；整理 task representation、context、rule 如何進入 RNN dynamics。
- Day 11：讀 Driscoll/Sussillo 2022 摘要、導論、主要圖；抓 shared dynamical motifs 與 flexible multitask computation。
- Day 12：完成 Driscoll/Sussillo 2022 筆記；整理 `motor cortex -> PFC -> multitask RNN` 的共同動力學語言。
- Day 13：快速補讀 Xiao-Jing Wang 或 Brunton & Kutz 的相關章節；聚焦 working memory、decision making、PCA/SVD/DMD，不做全書閱讀。
- Day 14：完成最終輸出：一份 10-15 頁 seminar outline，或一篇 1500-2500 字讀書報告。結尾必須包含三個批判：RLS 的生物可實作性、rate-RNN/低維流形的限制、Sussillo 路線與 Transformer/NeuroAI 路線的差異。

## 五、每日研讀策略

每次閱讀固定產出四件事：

1. 一句話摘要：這篇/這章到底解決什麼問題？
2. 一張圖：概念圖、流程圖、動力學示意圖或比較表。
3. 三個關鍵詞：例如 fixed point、readout、trajectory。
4. 一個批判問題：例如「這個模型真的能映射到生物突觸嗎？」

建議筆記模板：

```markdown
## 文獻

## 一句話結論

## 重要概念

## 方法或模型

## 與 FORCE / CTD 的關係

## 我不懂的地方

## 批判問題

## 下一步要查什麼
```

## 六、優先順序總表

如果今天只能開始讀 5 個檔案，順序如下：

1. `C:\Users\User\Documents\New project 2\David_Sussillo_NotebookLM_幻燈片分析整理.md`
2. `C:\Users\User\Downloads\MicrosoftEdgeDropFiles\Default\Driscoll_Sussilo_2022_Flexible multitask computation in recurrent networks utilizes shared dynamical motifs.pdf`
3. `C:\Users\User\Downloads\MicrosoftEdgeDropFiles\Default\Churchland_2012_Neural population dynamics during reaching.pdf`
4. `C:\Users\User\Downloads\MicrosoftEdgeDropFiles\Default\Yang_2019_Task representations in neural networks trained to perform many.pdf`
5. `C:\Users\User\Downloads\Documents\Steven H. Strogatz - Nonlinear Dynamics and Chaos-CRC Press (2024).pdf`

如果要補一本核心教科書：

- 首選：`C:\Users\User\Downloads\Documents\Thomas Trappenberg - Fundamentals of Computational Neuroscience-Oxford University Press (2023).pdf`
- 進階：`C:\Users\User\Downloads\Documents\Peter Dayan, L. F. Abbott - Theoretical Neuroscience_ Computational and Mathematical Modeling of Neural Systems-The MIT Press (2005).pdf`
- 認知神經科學延伸：`C:\Users\User\Downloads\Documents\Xiao-Jing Wang - Theoretical Neuroscience_ Understanding Cognition (2025, CRC Press) - libgen.li.pdf`

## 七、今天的最小可行讀法

如果今天只有 2-3 小時：

1. 先讀 `David_Sussillo_NotebookLM_幻燈片分析整理.md`。
2. 接著讀 Churchland 2012 的摘要、圖 1-3、討論。
3. 最後開 Driscoll/Sussillo 2022，只讀摘要、導論、主要圖，先不追方法細節。
4. 寫下三句話：
   - FORCE 想解決什麼？
   - 神經群體動力學和單一神經元編碼差在哪？
   - shared dynamical motifs 對「彈性計算」代表什麼？
