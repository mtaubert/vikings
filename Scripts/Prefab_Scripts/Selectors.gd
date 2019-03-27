extends Node2D

func update_selectors(selectedEntity, mousePos, grid):
	if selectedEntity != null:
		if grid.is_cell(mousePos):
			$Secondary_Selector.show()
			$Secondary_Selector.position = grid.get_tile_in_world_vector2(mousePos)
		else:
			$Secondary_Selector.hide()
	else:
		$Secondary_Selector.hide()
		if grid.is_cell(mousePos):
			$Selector.show()
			$Selector.position = grid.get_tile_in_world_vector2(mousePos)
		else:
			$Selector.hide()