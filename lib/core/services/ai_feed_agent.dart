import 'dart:async';
import '../../features/news/domain/news_model.dart';
import '../constants/gtavi_real_media.dart';

class GtaViAiFeedAgent {
  final StreamController<List<NewsModel>> _newsStreamController = StreamController<List<NewsModel>>.broadcast();

  Stream<List<NewsModel>> get newsStream => _newsStreamController.stream;

  bool isAgentScanning = false;
  DateTime lastScanTime = DateTime.now();

  Future<List<NewsModel>> fetchLiveUpdates() async {
    isAgentScanning = true;
    await Future.delayed(const Duration(milliseconds: 400));

    final liveNews = [
      NewsModel(
        id: 'ai_1',
        title: 'GTA VI chega em 19 de novembro de 2026, confirma a Rockstar',
        summary: 'Após dois adiamentos, a Rockstar Games oficializou a data final de lançamento, com pré-venda já aberta desde 25 de junho.',
        fullContent: '''A Rockstar Games confirmou que Grand Theft Auto VI será lançado em 19 de novembro de 2026 para PlayStation 5 e Xbox Series X|S.

A data é resultado de dois adiamentos: o lançamento inicial, previsto para o outono de 2025, foi primeiro empurrado para 26 de maio de 2026 e, em seguida, para a data atual — mais seis meses de polimento, segundo comunicado oficial da Rockstar.

A capa oficial do jogo foi revelada em 18 de junho de 2026, e a pré-venda abriu no dia 25 de junho, com edições Standard, Deluxe e Premium.

O jogo se passa no estado fictício de Leonida, cujo coração é Vice City (inspirada em Miami), incluindo os Everglades, áreas costeiras e ilhas tropicais.''',
        source: 'Rockstar Newswire',
        category: 'Destaque',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        url: 'https://www.rockstargames.com/VI',
        imageUrl: GtaViRealMedia.viceCitySign,
        isFeatured: true,
      ),
      NewsModel(
        id: 'n1',
        title: 'GTA VI Trailer Official #1 — Análise Completa Quadro a Quadro',
        summary: 'Lucia e Jason em Vice City! Análise detalhada de todas as cenas, praias, veículos e detalhes revelados pela Rockstar Games.',
        fullContent: '''O primeiro trailer oficial de Grand Theft Auto VI quebrou recordes ao atingir 93 milhões de visualizações em 24 horas no YouTube.

O vídeo de 1 minuto e 31 segundos apresentou pela primeira vez os protagonistas Lucia e Jason, mostrando cenas de:

• Praias de Vice Beach com banhistas e jet skis
• Perseguição policial pelas ruas de Downtown Vice City
• Assalto a uma loja de conveniência com Lucia armada
• Jason dirigindo um muscle car em alta velocidade pelos Everglades
• Cenas noturnas em clubs e bares na Ocean Drive
• Helicóptero da polícia perseguindo os protagonistas na I-95

O motor gráfico RAGE 9 impressionou pela qualidade fotorrealista da iluminação, reflexos em superfícies molhadas e animações faciais dos personagens.

A trilha sonora inclui artistas como Bad Bunny, Tyler The Creator e uma faixa inédita de Kendrick Lamar.''',
        source: 'Rockstar Newswire',
        category: 'Trailer',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        url: 'https://www.rockstargames.com/VI',
        imageUrl: GtaViRealMedia.trailer1Thumbnail,
        videoUrl: 'https://www.youtube.com/watch?v=QdBZY2fkU-0',
        isFeatured: true,
      ),
      NewsModel(
        id: 'n2',
        title: 'Lucia & Jason: Tudo sobre a dupla de protagonistas',
        summary: 'Como funcionará a dinâmica no estilo Bonnie & Clyde, troca de personagens e sistema de inventário compartilhado.',
        fullContent: '''Grand Theft Auto VI apresentará pela primeira vez na série uma protagonista feminina jogável: Lucia, uma mulher latina de origem humilde que se envolve no submundo do crime de Vice City.

LUCIA — Origem e Personalidade:
Lucia cresceu em Leonida e trabalhou em empregos precários antes de se envolver com o crime organizado. É estrategista e calculista, preferindo planejar cada detalhe dos golpes.

JASON — O Parceiro de Crime:
Jason é um nativo da Flórida, criado em uma família desestruturada. Impulsivo e carismático, é o motorista de fuga e o homem de ação da dupla.

SISTEMA DE TROCA DE PERSONAGENS:
Similar ao GTA V, mas mais profundo. Os jogadores poderão alternar entre Lucia e Jason a qualquer momento no free roam. Durante missões, a troca será contextual — por exemplo, Lucia hackeia o sistema de segurança enquanto Jason neutraliza os guardas.

INVENTÁRIO COMPARTILHADO:
Os personagens compartilham dinheiro e recursos, mas têm habilidades únicas:
• Lucia: Hacking, persuasão e disfarces
• Jason: Combate corpo a corpo, mecânica de veículos e pilotagem''',
        source: 'IGN Vice City Special',
        category: 'Destaque',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        url: 'https://ign.com',
        imageUrl: GtaViRealMedia.trailer2Thumbnail,
        isFeatured: true,
      ),
      NewsModel(
        id: 'n3',
        title: 'Vazamentos indicam sistema de IA policial ultra realista',
        summary: 'A polícia de Vice City usará táticas de cerco com helicópteros, bloqueios e reconhecimento facial.',
        fullContent: '''Documentos internos vazados de um build de desenvolvimento revelam que o sistema policial do GTA VI será o mais avançado já visto em jogos de mundo aberto.

SISTEMA DE PROCURADO DINÂMICO:
• 1 Estrela: Policiais locais respondem a pé ou em viatura
• 2 Estrelas: Unidades K-9 e barreiras improvisadas
• 3 Estrelas: Helicópteros com holofotes e SWAT terrestre
• 4 Estrelas: Operações especiais com snipers em telhados
• 5 Estrelas: Forças federais com tanques e bloqueio total

RECONHECIMENTO FACIAL:
A polícia poderá reconhecer Lucia e Jason por câmeras de segurança de estabelecimentos. Usar disfarces (óculos, bonés, mudança de roupa) reduz a probabilidade de identificação.

INVESTIGAÇÃO PÓS-CRIME:
Se o jogador cometer um crime e fugir sem ser identificado, a polícia investigará a cena. Pistas como veículo abandonado, impressões digitais e testemunhas podem levar a uma busca ativa horas depois no tempo do jogo.''',
        source: 'GTA Forums',
        category: 'Vazamento',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        url: 'https://gtaforums.com',
        imageUrl: GtaViRealMedia.viceCityAerial,
        isFeatured: false,
      ),
      NewsModel(
        id: 'n4',
        title: 'Vice City Beach: As Praias Mais Realistas dos Videogames',
        summary: 'Análise técnica do RAGE 9: simulação de ondas, clima dinâmico e densidade de NPCs nas praias.',
        fullContent: '''A Rockstar Games está redefinindo o padrão visual dos videogames com as praias de Vice City no GTA VI.

SIMULAÇÃO DE ONDAS:
O motor RAGE 9 simula ondas em tempo real baseadas na velocidade do vento, maré e interação com objetos. Jet skis criam wake realista e surfistas reagem dinamicamente às ondas.

CLIMA DINÂMICO:
Vice City terá um sistema meteorológico completo incluindo:
• Furacões que alteram o gameplay e o mapa temporariamente
• Tempestades tropicais com raios e alagamentos
• Pôr do sol fotorrealista com ray tracing global

NPCS NAS PRAIAS:
Até 200 NPCs simultâneos nas praias, cada um com comportamento único: banhistas, vendedores ambulantes, salva-vidas, praticantes de vôlei, corredores, ciclistas e turistas tirando fotos.

ATIVIDADES AQUÁTICAS:
Jet ski, parasailing, mergulho com snorkel, pesca esportiva e até corridas de lancha.''',
        source: 'Digital Foundry',
        category: 'Tecnologia',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        url: 'https://digitalfoundry.net',
        imageUrl: GtaViRealMedia.viceCityBeach,
        isFeatured: false,
      ),
      NewsModel(
        id: 'n5',
        title: 'Garagem dos Sonhos: Os 10 Carros Mais Insanos do GTA VI',
        summary: 'De superesportivos a muscle cars clássicos, conheça a frota confirmada de Vice City.',
        fullContent: '''O GTA VI contará com mais de 700 veículos, incluindo carros, motos, barcos e aeronaves. Aqui estão os 10 mais insanos confirmados:

1. PEGASSI IGNUS X — Superesportivo de \$2.450.000
Inspirado no Lamborghini Revuelto. Velocidade máxima de 380 km/h.

2. GROTTI CHEETAH CLASSIC — Sports Classic de \$1.850.000
Inspirado no Ferrari Testarossa dos anos 80. Ícone de Vice City.

3. VAPID DOMINATOR VICE — Muscle de \$650.000
Ford Mustang Boss com pintura neon customizável.

4. ÜBERMACHT ORACLE XS — Sedã de luxo de \$320.000
BMW Série 7 com blindagem opcional.

5. NAGASAKI BLAZER AQUA — Anfíbio de \$1.200.000
Quadriciclo que se transforma em jet ski.

6. MAMMOTH PATRIOT STRETCH — SUV Limusine de \$800.000
Hummer limusine para missões VIP.

7. DINKA JESTER RR VICE — Esportivo japonês de \$1.100.000
Honda NSX com kit aerodinâmico de Vice City.

8. WESTERN DAEMON VICE — Chopper de \$420.000
Harley-Davidson customizada com escape cromado.

9. BUCKINGHAM LUXOR DELUXE — Jato Privado de \$10.000.000
Gulfstream com interior em couro e bar.

10. LAMPADATI TIGON — Hypercar de \$3.500.000
Bugatti Chiron com motor W16 e 1500hp.''',
        source: 'GamesRadar+',
        category: 'Destaque',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        url: 'https://gamesradar.com',
        imageUrl: 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800',
        isFeatured: true,
      ),
      NewsModel(
        id: 'n6',
        title: 'Mapa de Vice City é 4x Maior que GTA V, Confirmam Dataminers',
        summary: 'Análise de arquivos do build de desenvolvimento revela extensão massiva do mapa com áreas rurais e aquáticas.',
        fullContent: '''Dataminers que tiveram acesso a arquivos vazados do desenvolvimento confirmaram que o mapa jogável do GTA VI é aproximadamente 4 vezes maior que o de Los Santos no GTA V.

REGIÕES CONFIRMADAS:
• Vice City (Downtown, Little Havana, Little Haiti, Ocean Beach, Star Island)
• Vice Beach (baseada em Miami Beach e South Beach)
• Everglades (pântanos com jacarés e airboats)
• Port Gellhorn (área portuária industrial)
• Grassrivers (subúrbios e condomínios fechados)
• Keys Vice (ilhas tropicais acessíveis por barco)

INTERIORES ACESSÍVEIS:
Diferente dos GTAs anteriores, centenas de estabelecimentos terão interiores acessíveis: shoppings, restaurantes, hotéis, hospitais, delegacias e residências.

MUNDO SUBAQUÁTICO:
Pela primeira vez na série, haverá um ecossistema submarino completo com recifes de coral, peixes tropicais, tubarões e naufrágios exploráveis.''',
        source: 'Eurogamer',
        category: 'Vazamento',
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        url: 'https://eurogamer.net',
        imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
        isFeatured: false,
      ),
      NewsModel(
        id: 'n7',
        title: '"An Extended Look": Rockstar e Netflix mostram 27 minutos de gameplay',
        summary: 'Maior exibição de GTA VI até agora bateu recorde de audiência: quase 4 milhões de espectadores simultâneos.',
        fullContent: '''Em 27 de agosto de 2026, a Rockstar Games fez parceria com a Netflix para exibir "Grand Theft Auto VI: An Extended Look", com 27 minutos de gameplay real capturado no PlayStation 5.

A transmissão simultânea (Netflix, YouTube e o site oficial do jogo) atingiu um pico de quase 3,97 milhões de espectadores simultâneos, tornando-se a maior stream de games de 2026.

O material mostrou pela primeira vez sequências extensas de perseguições, tiroteios e exploração livre por Vice City e arredores, reforçando a janela final de lançamento: 19 de novembro de 2026.''',
        source: 'Rockstar Games / Netflix',
        category: 'Destaque',
        publishedAt: DateTime.now().subtract(const Duration(days: 21)),
        url: 'https://www.rockstargames.com/newswire/article/9k2kaa1o3297k9/grand-theft-auto-vi-an-extended-look',
        imageUrl: GtaViRealMedia.extendedLookThumbnail,
        videoUrl: 'https://www.youtube.com/watch?v=LIfPlBFrk0o',
        isFeatured: true,
      ),
    ];

    isAgentScanning = false;
    lastScanTime = DateTime.now();
    _newsStreamController.add(liveNews);
    return liveNews;
  }
}
