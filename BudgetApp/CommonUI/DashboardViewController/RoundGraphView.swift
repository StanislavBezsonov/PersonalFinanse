import UIKit
import DGCharts

class RoundGraphView: UIView {
    private lazy var pieChartView: PieChartView = {
        let chart = PieChartView()
        let offsetRatio = UIScreen.main.bounds.width * 0.04
        chart.setExtraOffsets(left: offsetRatio, top: 0, right: offsetRatio, bottom: 0)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.drawEntryLabelsEnabled = false
        chart.highlightPerTapEnabled = false
        chart.backgroundColor = .clear
        chart.noDataText = "No expenses yet"
        chart.noDataFont = .systemFont(ofSize: 16, weight: .medium)
        chart.noDataTextColor = AppColor.elementText.uiColor
        chart.layer.shadowColor = UIColor.black.cgColor
        chart.layer.shadowOpacity = 0.5
        chart.layer.shadowRadius = 10
        chart.layer.shadowOffset = .zero

        setupLegend(for: chart)
        return chart
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pieChartView)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
           
    override func layoutSubviews() {
        super.layoutSubviews()
        pieChartView.legend.yOffset = self.frame.height * 0.07
    }
    
    func updateData(categorySums: [String: Double]) {
        if categorySums.isEmpty || categorySums.values.reduce(0, +) == 0 {
            pieChartView.data = nil
        } else {
            pieChartView.data = createChartData(from: categorySums)
            let total = categorySums.values.reduce(0, +)
            updateCenterText(total: total)
        }
        pieChartView.notifyDataSetChanged()
    }
     
    private func setupLegend(for chart: PieChartView) {
        let legend = chart.legend
        legend.enabled = true
        legend.font = .systemFont(ofSize: 14, weight: .semibold)
        legend.textColor = AppColor.elementText.uiColor
        legend.orientation = .horizontal
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.xEntrySpace = 6
        legend.yEntrySpace = 2
        legend.formSize = 12
        legend.formToTextSpace = 3
        legend.form = .default
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: topAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pieChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pieChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    
    private func createChartData(from categorySums: [String: Double]) -> PieChartData {
        let total = categorySums.values.reduce(0, +)
        let minPercentage = 0.03

        var mainEntries: [PieChartDataEntry] = []
        var otherTotal: Double = 0
        var colors: [UIColor] = []

        for (index, entry) in categorySums.enumerated() {
            let (key, value) = entry
            let percentage = value / total
            if percentage >= minPercentage {
                mainEntries.append(PieChartDataEntry(value: value, label: key))
                colors.append(ChartColors.color(for: index))
            } else {
                otherTotal += value
            }
        }

        if otherTotal > 0 {
            mainEntries.append(PieChartDataEntry(value: otherTotal, label: "Other"))
            colors.append(UIColor.white.withAlphaComponent(0.8))
        }

        let dataSet = PieChartDataSet(entries: mainEntries, label: "")
        dataSet.colors = colors
        dataSet.sliceSpace = 3
        dataSet.valueFont = .systemFont(ofSize: 14, weight: .bold)
        dataSet.valueTextColor = AppColor.elementText.uiColor

        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.4
        dataSet.valueLinePart2Length = 0.4
        dataSet.valueLineColor = AppColor.elementText.uiColor
        dataSet.valueLineWidth = 1
        dataSet.drawValuesEnabled = true

        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(IntegerValueFormatter())

        return data
    }

    
    private func centerText(for total: Double) -> NSAttributedString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 0
        
        let totalString = formatter.string(from: NSNumber(value: total)) ?? "\(total)"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: AppColor.elementText.uiColor,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: totalString, attributes: attributes)
    }

    private func updateCenterText(total: Double) {
        pieChartView.centerAttributedText = centerText(for: total)
    }
}

class IntegerValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))"
    }
}

