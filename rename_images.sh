#!/bin/bash
rename_img() {
    local old=$1
    local new=$2
    if [ -f "fig/$old" ]; then
        mv "fig/$old" "fig/$new"
        find src -type f -name "*.tex" -exec sed -i "s/$old/$new/g" {} +
    fi
}

rename_img "cover_paraiso_paredao_majestoso2.jpg" "book_cover_front.jpg"
rename_img "mapa_zonas_setores_left.jpg" "book_map_left.jpg"
rename_img "mapa_zonas_setores_right.jpg" "book_map_right.jpg"
rename_img "cover_falesias_e_paraiso.jpg" "falesias_cover.jpg"
rename_img "cover_muro_de_pedra_leste.jpg" "zona_baixa_cover.jpg"
rename_img "cover_catedral_norte.jpg" "catedral_cover.jpg"
rename_img "cover_batcaverna_face_leste.jpg" "catedral_cover_batcaverna.jpg"
rename_img "cover_paraiso_bloco_da_gruta.jpg" "paraiso_cover_gruta.jpg"

rename_img "topo_paraiso_paredao_majestoso_cleaned.jpg" "paraiso_cover.jpg"
rename_img "topo_paraiso_sectors.jpg" "paraiso_map_sectors.jpg"
rename_img "topo_paraiso_bloco_da_macambira.png" "paraiso_topo_macambira.png"
rename_img "topo_paraiso_bloco_do_portal_3.png" "paraiso_topo_portal_3.png"
rename_img "topo_paraiso_bloco_portal_topo.jpg" "paraiso_topo_portal.jpg"
rename_img "topo_paraiso_bloco_do_paraiso.png" "paraiso_topo_bloco.png"
rename_img "fenda_linda.jpg" "paraiso_act_fenda.jpg"
rename_img "paraiso_fenda_linda_topo.jpg" "paraiso_topo_fenda.jpg"
rename_img "topo_gameleira_topo.jpg" "paraiso_topo_gameleira.jpg"
rename_img "topo_paraiso_bloco_da_gameleira_full.jpg" "paraiso_map_gameleira.jpg"
rename_img "bloco_da_gruta.jpg" "paraiso_map_gruta.jpg"
rename_img "topo_paraiso_paredao_majestoso.jpg" "paraiso_topo_majestoso.jpg"

rename_img "topo_catedral_batcaverna_topo.jpg" "catedral_topo_batcaverna.jpg"
rename_img "topo_batcaverna_parede_direita_topo.jpg" "catedral_topo_batcaverna_direita.jpg"
rename_img "complexo_blocoes_da_catedral.jpg" "catedral_map_complexo.jpg"
rename_img "topo_route_catedral_mansao_comissario_gordon.jpg" "catedral_topo_mansao_gordon.jpg"
rename_img "topo_route_catedral_mansao_gota_serena.jpg" "catedral_topo_mansao_gota.jpg"
rename_img "topo_route_catedra_rupestre_aperta_com_carinho.jpg" "catedral_topo_rupestre_aperta.jpg"
rename_img "topo_rupestre_wide.jpeg" "catedral_cover_rupestre.jpeg"
rename_img "vale_perdido_drone.jpg" "catedral_map_vale.jpg"

rename_img "conquista_boca_torta.jpg" "talhado_act_boca_torta.jpg"

rename_img "muro_de_pedra_topo_above.jpg" "zona_baixa_map_muro.jpg"
rename_img "muro_de_pedra_pano.jpg" "zona_baixa_topo_muro.jpg"
rename_img "b_machado.jpg" "zona_baixa_act_machado.jpg"
