--[[
For various calls that don't need their own file
]]--

--Shonen Rarity
SMODS.Rarity{
    key = "shonen",
    default_weight = .01,
    badge_colour = HEX("FA6230"),
    pools = {["Joker"] = true},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

--Shonen Booster
SMODS.Booster{
    name = "Jump Pack",
    key = "jumppack_normal_1",
    kind = "Joker",
    atlas = "ShonenBooster",
    pos = { x = 0, y = 0 },
    config = { extra = 2, choose = 1 },
    cost = 4,
    order = 1,
    weight = .15,
    unlocked = true,
    discovered = true,
	create_card = function(self, card)
     return {set = "Joker", area = G.pack_cards, skip_materialize = true, key_append = "randshonen", rarity = "shon_shonen"}
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.choose, card.ability.extra} }
	end,
	group_key = "k_shon_jump_pack",
}

--custom color for Shonen Jokers
local shonencolors = loc_colour
function loc_colour(_c, _default)
  if not G.ARGS.LOC_COLOURS then
    shonencolors()
  end
  G.ARGS.LOC_COLOURS["shonen"] = HEX("FA6230")
  return shonencolors(_c, _default)
end

--called to ensure crashes don't happen
loc_colour()

--Shonen Tag
SMODS.Tag {
	object_type = "Tag",
	atlas = "ShonenTag",
	pos = { x = 0, y = 0 },
	config = { type = "new_blind_choice" },
	key = "shonen_tag",
	min_ante = 2,
  discovered = true,
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = { set = "Other", key = "p_shon_jumppack_normal_1", specific_vars = { 1, 2,} }
		return { vars = {} }
	end,
	apply = function(self, tag, context)
		if context and context.type == "new_blind_choice" then
			tag:yep("+", G.ARGS.LOC_COLOURS.shonen, function()
				local key = "p_shon_jumppack_normal_1"
				local card = Card(
					G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
					G.CARD_W * 1.27,
					G.CARD_H * 1.27,
					G.P_CARDS.empty,
					G.P_CENTERS[key],
					{ bypass_discovery_center = true, bypass_discovery_ui = true }
				)
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
}