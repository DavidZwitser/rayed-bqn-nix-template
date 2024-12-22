⟨c⇐color, win⇐window, d⇐draw, key, mouse⟩ ← r ← •Import "../rayed-bqn/rayed.bqn"
# raylib ← •Import "../rayed-bqn/imports/ralib-bqn/raylib.bqn"

win_size ← 400‿400
win_pos ← 200‿200

font_size ← 40
message ← "Hello World!"

_Start ← { Update _𝕣 𝕩:
  font←r.font.LoadBQN 200

	win.SetSize win_size
	win.SetPos win_pos

	Update font
}

Update ← {𝕊font:
  pos ← (win_size÷2) - ×⟜0.25 font_size × (≠message)‿1
  c.white‿font‿font_size d.Text pos‿message

  font
} d._withCanvas⟜32‿32‿32‿255


Update •_While_ (¬win.ShouldClose) _Start win._openAs "Template"
