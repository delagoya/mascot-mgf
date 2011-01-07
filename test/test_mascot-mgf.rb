require 'mascot/mgf'

class TestMascotMgf < Test::Unit::TestCase
  def setup
    @mgf_file = File.open(File.expand_path("example.mgf"))
  end

  def test_canary
    asset true, "The canary does not sing"
  end
  
  def test_open_file
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
  end
  
  def test_get_first_query
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
    first_query =<<EOF
BEGIN IONS
TITLE=example.9.9.2
RTINSECONDS=318.0218
PEPMASS=1019.0322875976562 563.95965576171875
CHARGE=2
484.3849487 0.5770078897
572.6119385 0.5543299913
603.659668 0.7869901657
612.3583984 0.7114390135
740.4682617 1.021142125
796.2832031 1.051657796
832.2305908 0.519821763
843.5834961 0.514819622
865.2956543 1.33468771
883.6113281 0.9751986265
913.4781494 0.4968527555
946.2431641 0.4950940609
956.1906738 0.4559304714
966.5097656 2.257080078
982.8709717 1.082980752
1058.980347 1.822528481
1070.601807 0.9599312544
1110.454956 0.5712217093
1171.136475 1.172691107
END IONS
EOF
    first_query.strip!
    assert_equal(mgf.readquery(), first_query)
  end
  
    
end
