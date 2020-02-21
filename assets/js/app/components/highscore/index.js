import React from 'react'
import { useTable, useSortBy } from 'react-table'

function Table({ columns, data }) {
  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    rows,
    prepareRow,
  } = useTable(
    {
      columns,
      data,
    },
    useSortBy
  )

  return (
    <>
      <table {...getTableProps()}>
        <thead>
          {headerGroups.map(headerGroup => (
            <tr {...headerGroup.getHeaderGroupProps()}>
              {headerGroup.headers.map(column => (
                // Add the sorting props to control sorting. For this example
                // we can add them into the header props
                <th {...column.getHeaderProps(column.getSortByToggleProps())}>
                  {column.render('Header')}
                  {/* Add a sort direction indicator */}
                  <span>
                    {column.isSorted
                      ? column.isSortedDesc
                        ? ' 🔽'
                        : ' 🔼'
                      : ''}
                  </span>
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody {...getTableBodyProps()}>
          {rows.map(
            (row, i) => {
              prepareRow(row);
              return (
                <tr {...row.getRowProps()}>
                  {row.cells.map(cell => {
                    return (
                      <td {...cell.getCellProps()}>{cell.render('Cell')}</td>
                    )
                  })}
                </tr>
              )}
          )}
        </tbody>
      </table>
    </>
  )
}

class Highscore extends React.Component {
  state = {
    players: [],
  }

  componentDidMount() {
    this.props.retrieveHighscores()
  }

  render() {
    return (
      <React.Fragment>
        <div className="highscore">
          <div className="title">Highscore</div>
          <div className="players">
            <Table columns={[
              {
                Header: 'Naam',
                accessor: 'name',
              },
              {
                Header: 'Gewonnen',
                accessor: 'won',
              },
              {
                Header: 'Elo',
                accessor: 'rating',
              },
            ]} data={this.props.highscore.players} />
          </div>
        </div>
      </React.Fragment>
    );
  }
}

export default Highscore
