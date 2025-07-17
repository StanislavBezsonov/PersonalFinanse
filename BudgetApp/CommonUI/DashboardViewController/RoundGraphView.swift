import UIKit
import DGCharts

class RoundGraphView: UIView {
    private var legendItems: [(color: UIColor, label: String)] = []

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
        chart.legend.enabled = false
        return chart
    }()

    private let legendContainerView = UIView()

    private lazy var legendCollectionView: UICollectionView = {
        let layout = CenterAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 1
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LegendItemCell.self, forCellWithReuseIdentifier: LegendItemCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .zero
        collectionView.contentOffset = .zero
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pieChartView)
        addSubview(legendContainerView)
        setupLegendContainer()
        setupConstraints()
        legendCollectionView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateData(categorySums: [String: Double]) {
        if categorySums.isEmpty || categorySums.values.reduce(0, +) == 0 {
            pieChartView.data = nil
        } else {
            let chartData = createChartData(from: categorySums)
            pieChartView.data = chartData
            updateLegend(dataSet: chartData.dataSets.first as? PieChartDataSet)
            let total = categorySums.values.reduce(0, +)
            updateCenterText(total: total)
        }
        pieChartView.notifyDataSetChanged()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: topAnchor),
            pieChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pieChartView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.79),

            legendContainerView.topAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 8),
            legendContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            legendContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            legendContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setupLegendContainer() {
        legendContainerView.translatesAutoresizingMaskIntoConstraints = false
        legendContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        legendContainerView.layer.cornerRadius = 10
        legendContainerView.clipsToBounds = true

        legendContainerView.addSubview(legendCollectionView)

        NSLayoutConstraint.activate([
            legendCollectionView.topAnchor.constraint(equalTo: legendContainerView.topAnchor, constant: 0),
            legendCollectionView.bottomAnchor.constraint(equalTo: legendContainerView.bottomAnchor, constant: 0),
            legendCollectionView.leadingAnchor.constraint(equalTo: legendContainerView.leadingAnchor, constant: 8),
            legendCollectionView.trailingAnchor.constraint(equalTo: legendContainerView.trailingAnchor, constant: -8)
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

    private func updateCenterText(total: Double) {
        pieChartView.centerAttributedText = centerText(for: total)
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

    private func updateLegend(dataSet: PieChartDataSet?) {
        guard let dataSet = dataSet else { return }
        legendItems = dataSet.entries.enumerated().compactMap {
            guard let entry = $0.element as? PieChartDataEntry else { return nil }
            return (dataSet.colors[$0.offset], entry.label ?? "—")
        }
        legendCollectionView.reloadData()
    }
}

extension RoundGraphView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        legendItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LegendItemCell.reuseIdentifier, for: indexPath) as! LegendItemCell
        let item = legendItems[indexPath.item]
        cell.configure(color: item.color, text: item.label)
        return cell
    }
}

extension RoundGraphView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = collectionView.bounds.width

        let item = legendItems[indexPath.item]
        let text = item.label

        let approximateWidth = maxWidth / 3

        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = text
        let size = label.sizeThatFits(CGSize(width: approximateWidth, height: CGFloat.greatestFiniteMagnitude))

        let width = size.width + 16
        let height = max(20, size.height)

        return CGSize(width: min(width, approximateWidth), height: height)
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

