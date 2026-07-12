"""Figure 2 — Human vs. machine ratings (10-fold cross-validation)."""
import os
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from scipy.stats import pearsonr

root = Path(os.environ.get("REPLICATE_STUDY_ROOT", Path(__file__).resolve().parents[2]))
raw = root / "data" / "raw"
out = os.environ.get("REPLICATE_PYTHON_OUTPUT", str(root / "outputs" / "fig_2.png"))
Path(out).parent.mkdir(parents=True, exist_ok=True)

merged_all = pd.read_csv(raw / "10fold_training_results.csv")
merged_all.dropna(subset=["TrueScore", "PredictedScore"], inplace=True)

trait_labels = {
    "attractiveness": "Attractiveness",
    "competence": "Competence",
    "trustworthiness": "Trustworthiness",
    "aggressiveness": "Aggressiveness",
}
plot_order = ["attractiveness", "competence", "trustworthiness", "aggressiveness"]

# matplotlib 3.6+ ships seaborn styles as seaborn-v0_8-*; older releases use
# seaborn-whitegrid. Fall back gracefully on servers with legacy matplotlib.
for _style in ("seaborn-v0_8-whitegrid", "seaborn-whitegrid", "ggplot"):
    try:
        plt.style.use(_style)
        break
    except OSError:
        pass
else:
    sns.set_style("whitegrid")

fig, axes = plt.subplots(2, 2, figsize=(10, 10))
axes = axes.flatten()

for i, trait in enumerate(plot_order):
    ax = axes[i]
    sub = merged_all[merged_all["trait"] == trait]
    r, p = pearsonr(sub["TrueScore"], sub["PredictedScore"])
    ax.scatter(
        sub["TrueScore"],
        sub["PredictedScore"],
        alpha=0.3,
        color="gray",
        s=15,
        edgecolor="none",
    )
    sns.regplot(
        x="TrueScore",
        y="PredictedScore",
        data=sub,
        ax=ax,
        scatter=False,
        line_kws={"color": "black", "linewidth": 1.5},
    )
    ax.set_title(trait_labels[trait], fontsize=14)
    ax.set_xlabel("Human Rating", fontsize=12)
    ax.set_ylabel("Machine Rating", fontsize=12)
    ax.set_xlim(1, 5)
    ax.set_ylim(1, 5)
    ax.set_aspect("equal", adjustable="box")
    p_text = "p < 0.001" if p < 0.001 else f"p = {p:.3f}"
    ax.text(
        0.95,
        0.05,
        f"r = {r:.3f}\n({p_text})",
        transform=ax.transAxes,
        fontsize=12,
        verticalalignment="bottom",
        horizontalalignment="right",
        bbox=dict(boxstyle="round,pad=0.3", fc="white", ec="none", alpha=0.8),
    )

fig.suptitle("Human vs. Machine Ratings from 10-Fold Cross-Validation", fontsize=16, y=0.98)
plt.tight_layout(rect=[0, 0, 1, 0.96])
fig.savefig(out, dpi=150, bbox_inches="tight")
plt.close(fig)
